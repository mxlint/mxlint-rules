# METADATA
# scope: package
# title: Avoid leftover TODO annotations
# description: TODO or FIXME notes in microflow annotations signal unfinished work. They should be resolved and removed before the microflow is considered complete.
# authors:
# - Xiwen Cheng <x@cinaq.com>
# related_resources:
# - https://sdf-docs.clevr.com/?docs=acr-rules/project-hygiene/todoannotations
# custom:
#  category: ProjectHygiene
#  rulename: TodoAnnotations
#  severity: LOW
#  rulenumber: "005_0011"
#  remediation: Resolve the outstanding work and remove the TODO/FIXME annotation.
#  input: "**/*$Microflow.yaml"
package app.mendix.microflows.todo_annotations

import rego.v1

annotation := rego.metadata.chain()[1].annotations

todo_pattern := `(?i)\b(todo|fixme)\b`

default allow := false

allow if count(errors) == 0

errors contains error if {
	some obj
	walk(input, [_, obj])
	obj["$Type"] == "Microflows$Annotation"
	regex.match(todo_pattern, object.get(obj, "Caption", ""))

	error := sprintf(
		"[%v, %v, %v] Microflow %v contains a TODO/FIXME annotation: %v",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
			input.Name,
			obj.Caption,
		],
	)
}
