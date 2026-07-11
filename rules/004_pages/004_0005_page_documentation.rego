# METADATA
# scope: package
# title: Pages should be documented
# description: Documentation on a page helps other developers understand its purpose and intended use. Pages without any documentation are harder to maintain.
# authors:
# - Xiwen Cheng <x@cinaq.com>
# related_resources:
# - https://sdf-docs.clevr.com/?docs=acr-rules/project-hygiene/pagedocumentation
# custom:
#  category: ProjectHygiene
#  rulename: PageDocumentation
#  severity: LOW
#  rulenumber: "004_0005"
#  remediation: Add documentation to the page describing its purpose.
#  input: .*\.Forms\$Page\.yaml
package app.mendix.pages.page_documentation

import rego.v1

annotation := rego.metadata.chain()[1].annotations

default allow := false

allow if count(errors) == 0

errors contains error if {
	input["$Type"] == "Forms$Page"
	documentation := trim_space(object.get(input, "Documentation", ""))
	count(documentation) == 0

	error := sprintf(
		"[%v, %v, %v] Page %v has no documentation",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
			object.get(input, "Name", "<unknown>"),
		],
	)
}
