const metadata = {
    scope: "package",
    title: "Module roles should be assigned to a user role",
    description: "A module role that is not connected to any user role can never be granted to a user. It is usually a leftover or a modeling mistake and should be assigned or removed.",
    authors: ["Xiwen Cheng <x@cinaq.com>"],
    related_resources: ["https://sdf-docs.clevr.com/?docs=acr-rules/reliability/unassignedmodulerole"],
    custom: {
        category: "Reliability",
        rulename: "UnassignedModuleRole",
        severity: "LOW",
        rulenumber: "001_0013",
        remediation: "Assign the module role to at least one user role, or remove it from the module security.",
        input: ".*Security\\$ProjectSecurity\\.yaml"
    }
};

// Collect every module role defined across all modules by reading each
// module's Security$ModuleSecurity.yaml. Returns a set of "Module.Role".
function definedModuleRoles() {
    const defined = new Set();
    let entries;
    try {
        entries = mxlint.io.listdir(".");
    } catch (e) {
        return defined;
    }
    for (const entry of entries) {
        try {
            if (!mxlint.io.isdir(entry)) {
                continue;
            }
            const moduleSecurity = mxlint.io.readYaml(entry + "/Security$ModuleSecurity.yaml");
            if (!moduleSecurity || !moduleSecurity.ModuleRoles) {
                continue;
            }
            for (const role of moduleSecurity.ModuleRoles) {
                defined.add(entry + "." + role.Name);
            }
        } catch (e) {
            // Not a module directory (no module security) - skip.
        }
    }
    return defined;
}

function rule(input = {}) {
    const errors = [];

    // Module roles that are assigned to at least one user role.
    const assigned = new Set();
    const userRoles = input.UserRoles || [];
    for (const userRole of userRoles) {
        for (const moduleRole of (userRole.ModuleRoles || [])) {
            assigned.add(moduleRole);
        }
    }

    const defined = definedModuleRoles();
    for (const moduleRole of defined) {
        if (!assigned.has(moduleRole)) {
            errors.push(`[${metadata.custom.severity}, ${metadata.custom.category}, ${metadata.custom.rulenumber}] Module role ${moduleRole} is not assigned to any user role.`);
        }
    }

    const allow = errors.length === 0;
    return { allow, errors };
}
