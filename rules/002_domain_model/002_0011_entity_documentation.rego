# METADATA
# scope: package
# title: Large entities should be documented
# description: When an entity has many attributes, documentation (for example the reasoning behind associations or attribute choices) improves maintainability. Another developer can then quickly see what the entity is used for.
# authors:
# - Xiwen Cheng <x@cinaq.com>
# related_resources:
# - https://sdf-docs.clevr.com/?docs=acr-rules/project-hygiene/entitydocumentation
# custom:
#  category: Maintainability
#  rulename: EntityDocumentation
#  severity: LOW
#  rulenumber: "002_0011"
#  remediation: Add documentation to the entity describing its purpose.
#  input: .*/DomainModels\$DomainModel\.yaml
package app.mendix.domain_model.entity_documentation

import rego.v1

annotation := rego.metadata.chain()[1].annotations

# Minimum number of attributes before documentation is required.
min_attributes := 10

default allow := false

allow if count(errors) == 0

errors contains error if {
	some entity in input.Entities
	count(entity.Attributes) >= min_attributes
	documentation := trim_space(object.get(entity, "Documentation", ""))
	count(documentation) == 0

	error := sprintf(
		"[%v, %v, %v] Entity %v has %v attributes but no documentation",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
			entity.Name,
			count(entity.Attributes),
		],
	)
}
