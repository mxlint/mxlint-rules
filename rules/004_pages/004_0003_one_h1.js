const metadata = {
    scope: "package",
    title: "Only one h1 tag is allowed per page",
    description: "Only one h1 tag is allowed per page to ensure that the page is accessible to users with disabilities",
    authors: ["Xiwen Cheng <x@cinaq.com>"],
    custom: {
        category: "Accessibility",
        rulename: "OneH1TagPerPage",
        severity: "HIGH",
        rulenumber: "004_0003",
        remediation: "Restructure the page to have only one h1 tag",
        input: ".*/*\\.(Forms\\$Page|Forms\\$Snippet)\\.yaml"
    }
};


function rule(input = {}) {

    const errors = [];
    const renderModes = [];
    
    // Helper function to traverse the object recursively
    function traverse(obj) {
        if (obj && typeof obj === 'object') {
            // Check if this is a widget with a RenderMode property
            if (obj.RenderMode !== undefined) {
                renderModes.push(obj.RenderMode);
            }
            
            // Recursively traverse all properties
            for (const key in obj) {
                if (obj.hasOwnProperty(key)) {
                    traverse(obj[key]);
                }
            }
        }
    }
    
    // Start traversal from the input
    traverse(input);

    numberOfH1 = 0
    for (const renderMode of renderModes) {
        if (renderMode === "H1") {
            numberOfH1++;
        }
    }

    if (numberOfH1 > 1) {
        errors.push(`[${metadata.custom.severity}, ${metadata.custom.category}, ${metadata.custom.rulenumber}] found ${numberOfH1} h1 tags in the page. ${metadata.title}`);
    }

    // Determine final authorization decision
    const allow = errors.length === 0;
    
    return {
        allow,
        errors
    };
}
