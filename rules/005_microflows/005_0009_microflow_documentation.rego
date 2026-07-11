# METADATA
# scope: package
# title: Complex microflows should be documented
# description: With difficult microflows it is very helpful for other developers to see documentation about decisions or modeling choices. Microflows above a minimum number of actions should carry documentation.
# authors:
# - Xiwen Cheng <x@cinaq.com>
# related_resources:
# - https://sdf-docs.clevr.com/?docs=acr-rules/project-hygiene/microflowdocumentation
# custom:
#  category: Maintainability
#  rulename: MicroflowDocumentation
#  severity: LOW
#  rulenumber: "005_0009"
#  remediation: Add documentation to the microflow describing its purpose and any important modeling choices.
#  input: "**/*$Microflow.yaml"
package app.mendix.microflows.microflow_documentation

import rego.v1

annotation := rego.metadata.chain()[1].annotations

# Minimum number of action activities before documentation is required.
min_actions := 10

default allow := false

allow if count(errors) == 0

action_count := count([obj |
	walk(input, [_, obj])
	obj["$Type"] == "Microflows$ActionActivity"
])

errors contains error if {
	action_count >= min_actions
	documentation := trim_space(object.get(input, "Documentation", ""))
	count(documentation) == 0

	error := sprintf(
		"[%v, %v, %v] Microflow %v has %v actions but no documentation",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
			input.Name,
			action_count,
		],
	)
}
