const metadata = {
    scope: "package",
    title: "Commit actions with a loop (including submicroflows)",
    description: "Commiting objects within a loop will fire a SQL Update query for each iteration. This includes commits in called submicroflows.",
    authors: ["Viktor Berlov <viktor@cinaq.com>"],
    custom: {
        category: "Microflows",
        rulename: "AvoidCommitInLoopWithSubmicroflows",
        severity: "MEDIUM",
        rulenumber: "005_0006",
        remediation: "Consider committing objects outside the loop. Within the loop, add them to a list.",
        input: ".*\\$Microflow\\.yaml"
    }
};

function rule(input = {}) {
    const errors = [];
    const visitedMicroflows = new Set();

    try {
        // Check for commits directly in loops
        checkCommitsInLoops(input, errors, "");

        // Check for commits in called submicroflows within loops
        checkSubmicroflowsInLoops(input, errors, visitedMicroflows, "");
    } catch (e) {
        errors.push(`[${metadata.custom.severity}, ${metadata.custom.category}, ${metadata.custom.rulenumber}] Error checking commit actions in loop: ${e.message}`);
    }

    return {
        allow: errors.length === 0,
        errors
    };
}

/**
 * Check for direct commit actions within loops
 */
function checkCommitsInLoops(microflow, errors, chain) {
    const name = microflow.Name || "Unknown";
    const mainFunction = microflow.MainFunction || [];

    // Check for LoopedActivity with commit actions
    mainFunction.forEach(attr => {
        if (attr.Attributes && attr.Attributes["$Type"] === "Microflows$LoopedActivity") {
            const objects = attr.Attributes.ObjectCollection?.Objects || [];

            objects.forEach(obj => {
                // Check for direct CommitAction
                if (obj.Action && obj.Action["$Type"] === "Microflows$CommitAction") {
                    const errorChain = chain ? `${chain} → ${name}` : name;
                    errors.push(
                        `[${metadata.custom.severity}, ${metadata.custom.category}, ${metadata.custom.rulenumber}] Commit actions inside ${errorChain} loop`
                    );
                }

                // Check for ChangeAction with Commit set to Yes
                if (obj.Action && obj.Action["$Type"] === "Microflows$ChangeAction" && obj.Action.Commit === "Yes") {
                    const errorChain = chain ? `${chain} → ${name}` : name;
                    errors.push(
                        `[${metadata.custom.severity}, ${metadata.custom.category}, ${metadata.custom.rulenumber}] Commit set to Yes for Change actions inside ${errorChain} loop`
                    );
                }
            });
        }
    });
}

/**
 * Recursively check for submicroflow calls within loops and their contents
 */
function checkSubmicroflowsInLoops(microflow, errors, visitedMicroflows, chain) {
    const name = microflow.Name || "Unknown";

    // Prevent infinite loops
    if (visitedMicroflows.has(name)) {
        return;
    }
    visitedMicroflows.add(name);

    const mainFunction = microflow.MainFunction || [];

    mainFunction.forEach(attr => {
        if (attr.Attributes && attr.Attributes["$Type"] === "Microflows$LoopedActivity") {
            const objects = attr.Attributes.ObjectCollection?.Objects || [];

            objects.forEach(obj => {
                // Check for MicroflowCallAction (submicroflow calls)
                if (obj.Action && obj.Action["$Type"] === "Microflows$MicroflowCallAction") {
                    const submicroflowName = extractMicroflowName(obj.Action);

                    if (submicroflowName) {
                        try {
                            // Build the chain for error messages
                            const newChain = chain ? `${chain} → ${name}` : name;

                            // Try to read the submicroflow
                            const submicroflowContent = mxlint.io.readfile(`${submicroflowName}$Microflow.yaml`);

                            if (submicroflowContent) {
                                // Check if the submicroflow contains ANY commits (anywhere, not just in loops)
                                checkForAnyCommits(submicroflowContent, errors, newChain);
                            }
                        } catch (e) {
                            // Silently continue if submicroflow cannot be read
                            // This is normal as not all microflows may be available
                        }
                    }
                }
            });
        }
    });
}

/**
 * Recursively check if a microflow or any of its called submicroflows contains any commits
 */
function checkForAnyCommits(microflow, errors, chain) {
    const name = microflow.Name || "Unknown";
    const mainFunction = microflow.MainFunction || [];

    mainFunction.forEach(attr => {
        if (attr.Attributes) {
            const objects = attr.Attributes.ObjectCollection?.Objects || [];

            objects.forEach(obj => {
                // Check for any CommitAction
                if (obj.Action && obj.Action["$Type"] === "Microflows$CommitAction") {
                    const errorChain = chain ? `${chain} → ${name}` : name;
                    errors.push(
                        `[${metadata.custom.severity}, ${metadata.custom.category}, ${metadata.custom.rulenumber}] Commit actions found in submicroflow called from loop: ${errorChain}`
                    );
                }

                // Check for ChangeAction with Commit set to Yes
                if (obj.Action && obj.Action["$Type"] === "Microflows$ChangeAction" && obj.Action.Commit === "Yes") {
                    const errorChain = chain ? `${chain} → ${name}` : name;
                    errors.push(
                        `[${metadata.custom.severity}, ${metadata.custom.category}, ${metadata.custom.rulenumber}] Commit set to Yes in submicroflow called from loop: ${errorChain}`
                    );
                }

                // Recursively check nested submicroflow calls
                if (obj.Action && obj.Action["$Type"] === "Microflows$MicroflowCallAction") {
                    const submicroflowName = extractMicroflowName(obj.Action);

                    if (submicroflowName) {
                        try {
                            const newChain = chain ? `${chain} → ${name}` : name;
                            const submicroflowContent = mxlint.io.readfile(`${submicroflowName}$Microflow.yaml`);

                            if (submicroflowContent) {
                                checkForAnyCommits(submicroflowContent, errors, newChain);
                            }
                        } catch (e) {
                            // Silently continue if submicroflow cannot be read
                        }
                    }
                }
            });
        }
    });
}

/**
 * Extract microflow name from MicroflowCallAction
 * The microflow reference is typically in MicroflowName or microflowname property
 */
function extractMicroflowName(action) {
    if (!action) return null;

    // Try various possible property names
    const possibleNames = [
        action.MicroflowName,
        action.microflowname,
        action.MicroflowQualifiedName,
        action.microflowQualifiedName
    ];

    for (const name of possibleNames) {
        if (name && typeof name === "string") {
            // If it's a qualified name like "Module.Microflow", keep as is
            return name;
        }
    }

    return null;
}
