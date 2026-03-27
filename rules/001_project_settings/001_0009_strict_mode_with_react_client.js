const metadata = {
  scope: "package",
  title: "Ensure strict mode is enabled when using the React client",
  description:
    "When React is enabled in Project Settings, StrictMode must also be enabled in Project Security for security and stability",
  authors: ["Jurre Tanja <jurre.tanja@siemens.com>"],
  custom: {
    category: "Security",
    rulename: "StrictModeWithReactClient",
    severity: "HIGH",
    rulenumber: "001_0009",
    remediation: "Enable Strict mode in the Security settings",
    input: ".*\\$ProjectSettings\\.yaml",
  },
};

function rule(input = {}) {
  const errors = [];

  try {
    // Navigate into Settings array to find UseOptimizedClient
    let useOptimizedClient = undefined;

    if (input.Settings && Array.isArray(input.Settings)) {
      // Find the Forms$WebUIProjectSettingsPart section
      const webUISettings = input.Settings.find(
        (s) => s.$Type === "Forms$WebUIProjectSettingsPart",
      );
      if (webUISettings) {
        useOptimizedClient = webUISettings.UseOptimizedClient;
      }
    }

    // Check if UseOptimizedClient is enabled
    if (useOptimizedClient === true || useOptimizedClient === "Yes") {
      // Read the ProjectSecurity.yaml file to check StrictMode
      try {
        const securityContent = mxlint.io.readfile(
          "Security$ProjectSecurity.yaml",
        );

        if (securityContent) {
          // Parse the YAML string to find StrictMode value
          const strictModeMatch =
            securityContent.match(/^StrictMode:\s*(.+)$/m);
          let strictModeValue = null;

          if (strictModeMatch) {
            const value = strictModeMatch[1].trim();
            strictModeValue = value === "true" || value === true;
          }

          // Check if StrictMode is enabled
          if (strictModeValue !== true) {
            errors.push(`[${metadata.custom.severity}, ${metadata.custom.category}, ${metadata.custom.rulenumber}] StrictMode must be enabled in Project Security when UseOptimizedClient is enabled in Project Settings. Current
   StrictMode value: ${strictModeValue}`);
          }
        }
      } catch (securityError) {
        errors.push(
          `[${metadata.custom.severity}, ${metadata.custom.category}, ${metadata.custom.rulenumber}] Failed to read Security$ProjectSecurity.yaml: ${securityError.message}`,
        );
      }
    }
  } catch (e) {
    errors.push(
      `[${metadata.custom.severity}, ${metadata.custom.category}, ${metadata.custom.rulenumber}] Error checking strict mode configuration: ${e.message}`,
    );
  }

  return {
    allow: errors.length === 0,
    errors,
  };
}
