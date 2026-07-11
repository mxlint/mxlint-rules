# METADATA
# scope: package
# title: Attributes should be named in PascalCase
# description: Consistent PascalCase attribute names (starting with an uppercase letter, letters and digits only) improve readability and maintainability across the domain model.
# authors:
# - Xiwen Cheng <x@cinaq.com>
# related_resources:
# - https://sdf-docs.clevr.com/?docs=acr-rules/project-hygiene/attributenameentity
# custom:
#  category: ProjectHygiene
#  rulename: AttributeNaming
#  severity: LOW
#  rulenumber: "002_0013"
#  remediation: Rename the attribute to PascalCase, e.g. "OrderDate" instead of "order_date".
#  input: .*/DomainModels\$DomainModel\.yaml
package app.mendix.domain_model.attribute_naming

import rego.v1

annotation := rego.metadata.chain()[1].annotations

pascal_case := `^[A-Z][a-zA-Z0-9]*$`

default allow := false

allow if count(errors) == 0

errors contains error if {
	some entity in input.Entities
	some attribute in entity.Attributes
	not regex.match(pascal_case, attribute.Name)

	error := sprintf(
		"[%v, %v, %v] Attribute %v.%v is not PascalCase",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
			entity.Name,
			attribute.Name,
		],
	)
}
