const metadata = {
    scope: "package",
    title: "Inheritance should be limited to 2 levels",
    description: "Deep generalization hierarchies are hard to maintain and have a negative performance impact. Inheritance should be limited to at most two levels.",
    authors: ["Xiwen Cheng <x@cinaq.com>"],
    related_resources: ["https://sdf-docs.clevr.com/?docs=acr-rules/architecture/multilevelinheritance"],
    custom: {
        category: "Architecture",
        rulename: "MultiLevelInheritance",
        severity: "MEDIUM",
        rulenumber: "002_0012",
        remediation: "Flatten the hierarchy. Instead of deep inheritance, associate objects or move attributes up into the super entity with an ObjectType enumeration.",
        input: ".*/DomainModels\\$DomainModel\\.yaml"
    }
};

// Maximum number of ancestors an entity may have through inheritance.
const MAX_LEVELS = 2;

// Resolve a fully qualified entity name (e.g. "Module.Entity") to its entity
// definition by reading the domain model of the referenced module.
function resolveEntity(qualifiedName) {
    const parts = qualifiedName.split(".");
    const moduleName = parts[0];
    const entityName = parts.slice(1).join(".");
    try {
        const domainModel = mxlint.io.readYaml(moduleName + "/DomainModels$DomainModel.yaml");
        if (!domainModel || !domainModel.Entities) {
            return undefined;
        }
        return domainModel.Entities.find(e => e.Name === entityName);
    } catch (e) {
        // Domain model not available (e.g. platform System module) - stop here.
        return undefined;
    }
}

// Extract the generalization reference of an entity, or undefined if it does
// not inherit from another entity.
function generalizationOf(entity) {
    if (!entity || !entity.MaybeGeneralization) {
        return undefined;
    }
    return entity.MaybeGeneralization.Generalization;
}

// Count how many ancestors an entity has by walking up the generalization chain.
function ancestorCount(generalization) {
    let count = 0;
    let current = generalization;
    while (current) {
        count++;
        if (count > 50) {
            // Safety brake against cyclic definitions.
            break;
        }
        const moduleName = current.split(".")[0];
        if (moduleName === "System") {
            // The platform System module is the base of the hierarchy.
            break;
        }
        const parent = resolveEntity(current);
        current = generalizationOf(parent);
    }
    return count;
}

function rule(input = {}) {
    const errors = [];
    const entities = input.Entities || [];

    for (const entity of entities) {
        const generalization = generalizationOf(entity);
        if (!generalization) {
            continue;
        }
        const levels = ancestorCount(generalization);
        if (levels > MAX_LEVELS) {
            errors.push(`[${metadata.custom.severity}, ${metadata.custom.category}, ${metadata.custom.rulenumber}] Entity ${entity.Name} inherits through ${levels} levels, which exceeds the maximum of ${MAX_LEVELS}.`);
        }
    }

    const allow = errors.length === 0;
    return { allow, errors };
}
