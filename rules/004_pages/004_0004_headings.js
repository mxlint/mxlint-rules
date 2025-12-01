const metadata = {
    scope: "package",
    title: "Headings are in ascending order",
    description: "Headings are in ascending order to ensure that the page is accessible to users with disabilities",
    authors: ["Xiwen Cheng <x@cinaq.com>"],
    custom: {
        category: "Accessibility",
        rulename: "HeadingsInAscendingOrder",
        severity: "HIGH",
        rulenumber: "004_0004",
        remediation: "Restructure the page to have headings in ascending order",
        input: ".*/*\\.(Forms\\$Page|Forms\\$Snippet)\\.yaml"
    }
};


function rule(input = {}) {

    const errors = [];
    const renderModes = [];
    const expectedOrder = ["H1", "H2", "H3", "H4", "H5", "H6"];
    
    // Helper function to traverse the object recursively
    function traverse(obj) {
        if (obj && typeof obj === 'object') {
            // Check if this is a widget with a RenderMode property
            if (obj.RenderMode !== undefined && expectedOrder.indexOf(obj.RenderMode) !== -1) {
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

    // ensure the rendermodes have a structure of [H1, H2, H3, H4, H5, H6] where the order is correct
    let stack = [];
    for (const renderMode of renderModes) {
        if (stack.length === 0) {
            if (renderMode !== "H1") {
                errors.push(`[${metadata.custom.severity}, ${metadata.custom.category}, ${metadata.custom.rulenumber}] found ${renderMode} in the page. Expected H1 as the first tag.`);
            }
            stack.push(renderMode);
        } else {
            if (expectedOrder.indexOf(renderMode) === expectedOrder.indexOf(stack[stack.length - 1])) {
                // ok
            } else if (expectedOrder.indexOf(renderMode) === expectedOrder.indexOf(stack[stack.length - 1]) - 1) {
                stack.pop();
            } else if (expectedOrder.indexOf(renderMode) === expectedOrder.indexOf(stack[stack.length - 1]) + 1) {
                stack.push(renderMode);
            } else {
                errors.push(`[${metadata.custom.severity}, ${metadata.custom.category}, ${metadata.custom.rulenumber}] found ${renderMode} in the page. Expected ${expectedOrder[expectedOrder.indexOf(renderMode) - 1]} to be before ${renderMode}.`);
            }
        }
    }

    // Determine final authorization decision
    const allow = errors.length === 0;
    
    return {
        allow,
        errors
    };
}
