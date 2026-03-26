const metadata = {
    scope: "package",
    title: "Ensure strict mode is enabled when using the React client",
    description: "When React is enabled in Project Settings, StrictMode must also be enabled in Project Security for security and stability",
    authors:
      - Jurre Tanja <jurre.tanja@siemens.com>
    custom: {
        category: "Security",
        rulename: "StrictModeWithOptimizedClient",
        severity: "HIGH",
        rulenumber: "001_0009",
        remediation: "Enable Strict mode in the Security settings",
        input: ".*\\$ProjectSettings\\.yaml"
    }
};

function rule(input = {}) {
    const errors = [];

    try {
        // Check if UseOptimizedClient is enabled
        if (input.UseOptimizedClient === true) {
            // Read the ProjectSecurity.yaml file to check StrictMode
            try {
                const securityContent = mxlint.io.readfile("Security$ProjectSecurity.yaml");

                // Check if StrictMode is enabled
                if (!securityContent || securityContent.StrictMode !== true) {
                    errors.push(`[${metadata.custom.severity}, ${metadata.custom.category}, ${metadata.custom.rulenumber}] StrictMode must be enabled in Project Security when UseOptimizedClient is enabled in Project Settings`);
                }
            } catch (securityError) {
                errors.push(`[${metadata.custom.severity}, ${metadata.custom.category}, ${metadata.custom.rulenumber}] Failed to read Security$ProjectSecurity.yaml: ${securityError.message}`);
            }
        }
    } catch (e) {
        errors.push(`[${metadata.custom.severity}, ${metadata.custom.category}, ${metadata.custom.rulenumber}] Error checking strict mode configuration: ${e.message}`);
    }

    return {
        allow: errors.length === 0,
        errors
    };
}
