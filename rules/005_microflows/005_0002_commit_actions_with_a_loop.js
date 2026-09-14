const metadata = {
    scope: "package",
    title: "Commit actions with a loop",
    description: "Commiting objects within a loop will fire a SQL Update query for each iteration. This applies whether the commit sits directly in the loop or is reached via a called microflow.",
    authors: [
        "Viktor Berlov <viktor@cinaq.com>",
        "Jurre Tanja <jurre.tanja@mendix.com>"
    ],
    custom: {
        category: "Microflows",
        rulename: "AvoidCommitInLoop",
        severity: "MEDIUM",
        rulenumber: "005_0002",
        remediation: "Consider committing objects outside the loop. Within the loop, add them to a list.",
        input: ".*\\$Microflow\\.yaml"
    }
};

function rule(input = {}) {
    const errors = [];

    function findNodes(node, matches, found) {
        found = found || [];
        if (!node || typeof node !== "object") return found;
        if (matches(node)) found.push(node);
        for (const key of Object.keys(node)) {
            const value = node[key];
            if (Array.isArray(value)) {
                for (const item of value) findNodes(item, matches, found);
            } else if (value && typeof value === "object") {
                findNodes(value, matches, found);
            }
        }
        return found;
    }

    const isLoopedActivity = n => n["$Type"] === "Microflows$LoopedActivity";

    const isMicroflowCallActivity = n =>
        n["$Type"] === "Microflows$ActionActivity" &&
        n.Action &&
        n.Action["$Type"] === "Microflows$MicroflowCallAction" &&
        n.Action.MicroflowCall &&
        n.Action.MicroflowCall.Microflow;

    const isCommittingActivity = n =>
        n["$Type"] === "Microflows$ActionActivity" &&
        n.Action && (
            n.Action["$Type"] === "Microflows$CommitAction" ||
            (n.Action["$Type"] === "Microflows$ChangeAction" && n.Action.Commit === "Yes") ||
            (n.Action["$Type"] === "Microflows$CreateChangeAction" && n.Action.Commit === "Yes")
        );

    // --- Document resolution -------------------------------------------------
    // "Module.Name" hides the folder a document sits in: try the direct path, then
    // app.yaml, the export's path map. Twin in 004_0003 (no imports in this runtime).

    const documentCache = {};  // one document only: each gets a fresh scope
    let documentPaths = null;

    // Module name -> every document below it, by file name. A top-level directory
    // of the export is a module, and its name is the one the qualified name uses.
    function documentPathsPerModule() {
        if (documentPaths) return documentPaths;
        documentPaths = {};
        let app = null;
        try {
            app = mxlint.io.readYaml("app.yaml");
        } catch (e) {
            // no path map: only documents at their module root will resolve
        }
        for (const root of (app && app.content) || []) {
            if (!root || root.type !== "directory" || !root.name) continue;
            const documentsInModule = documentPaths[root.name] || (documentPaths[root.name] = {});
            const stack = [root];
            while (stack.length > 0) {
                const node = stack.pop();
                for (const child of node.content || []) {
                    if (child.type === "directory") {
                        stack.push(child);
                    } else if (child.name && child.path && !(child.name in documentsInModule)) {
                        documentsInModule[child.name] = child.path;
                    }
                }
            }
        }
        return documentPaths;
    }

    // "Module.Name" -> the document, or null when it is not in the export.
    function readDocument(qualifiedName, documentType) {
        const key = documentType + ":" + qualifiedName;
        if (key in documentCache) return documentCache[key];

        let document = null;
        const nameParts = qualifiedName.split(".");
        if (nameParts.length === 2) {
            const moduleName = nameParts[0];
            const documentName = nameParts[1];
            const fileName = documentName + "." + documentType + ".yaml";
            try {
                document = mxlint.io.readYaml(moduleName + "/" + fileName);
            } catch (e) {
                document = null;
            }
            // Not at the module root: ask the export's path map.
            if (!document) {
                const documentsInModule = documentPathsPerModule()[moduleName];
                if (documentsInModule && fileName in documentsInModule) {
                    try {
                        document = mxlint.io.readYaml(documentsInModule[fileName]);
                    } catch (e) {
                        document = null;
                    }
                }
            }
            // A file that turned out to hold a different document is not a match.
            if (document && document.Name && document.Name !== documentName) document = null;
        }
        documentCache[key] = document || null;
        return documentCache[key];
    }

    // --- Call graph ------------------------------------------------------------
    // An unresolvable reference is reported, not assumed harmless: a failed lookup
    // is indistinguishable from a microflow that does not commit.
    function searchCallChainForCommit(qualifiedName, alreadySearched) {
        if (alreadySearched.has(qualifiedName)) return { commits: false, unresolved: null };
        alreadySearched.add(qualifiedName);

        const microflow = readDocument(qualifiedName, "Microflows$Microflow");
        if (!microflow) return { commits: false, unresolved: qualifiedName };
        if (findNodes(microflow, isCommittingActivity).length > 0) return { commits: true, unresolved: null };

        let unresolved = null;
        for (const call of findNodes(microflow, isMicroflowCallActivity)) {
            const calleeResult = searchCallChainForCommit(call.Action.MicroflowCall.Microflow, alreadySearched);
            if (calleeResult.commits) return calleeResult;
            if (calleeResult.unresolved && !unresolved) unresolved = calleeResult.unresolved;
        }
        return { commits: false, unresolved: unresolved };
    }

    const prefix = "[" + metadata.custom.severity + ", " + metadata.custom.category + ", " + metadata.custom.rulenumber + "] ";
    const microflowName = input.Name || "unknown";

    const loops = findNodes(input, isLoopedActivity);
    const reportedActivities = new Set();
    const reportedCalls = new Set();

    for (const loop of loops) {
        for (const activity of findNodes(loop, isCommittingActivity)) {
            if (reportedActivities.has(activity)) continue;
            reportedActivities.add(activity);
            errors.push(prefix + activity.Action["$Type"] + " inside " + microflowName + " loop");
        }
        for (const call of findNodes(loop, isMicroflowCallActivity)) {
            const calledMicroflow = call.Action.MicroflowCall.Microflow;
            if (reportedCalls.has(calledMicroflow)) continue;
            const result = searchCallChainForCommit(calledMicroflow, new Set());
            if (result.commits) {
                reportedCalls.add(calledMicroflow);
                errors.push(prefix + "Microflow " + calledMicroflow + " called from " + microflowName + " loop commits (directly or transitively)");
            } else if (result.unresolved) {
                reportedCalls.add(calledMicroflow);
                errors.push(prefix + "Microflow " + calledMicroflow + " called from " + microflowName + " loop " +
                    (result.unresolved === calledMicroflow
                        ? "could not be resolved"
                        : "reaches " + result.unresolved + ", which could not be resolved") +
                    "; it cannot be verified that it does not commit");
            }
        }
    }

    return { allow: errors.length === 0, errors };
}
