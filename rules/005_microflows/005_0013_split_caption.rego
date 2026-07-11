# METADATA
# scope: package
# title: Splits should have a descriptive caption
# description: A caption on an exclusive or inclusive split documents the decision being made and makes the microflow much easier to read. Splits without a caption hide their intent.
# authors:
# - Xiwen Cheng <x@cinaq.com>
# related_resources:
# - https://sdf-docs.clevr.com/?docs=acr-rules/maintainability/splitcaption
# custom:
#  category: Maintainability
#  rulename: SplitCaption
#  severity: LOW
#  rulenumber: "005_0013"
#  remediation: Give each split a short caption describing the decision it represents.
#  input: "**/*$Microflow.yaml"
package app.mendix.microflows.split_caption

import rego.v1

annotation := rego.metadata.chain()[1].annotations

split_types := {"Microflows$ExclusiveSplit", "Microflows$InclusiveSplit"}

default allow := false

allow if count(errors) == 0

errors contains error if {
	some obj
	walk(input, [_, obj])
	split_types[object.get(obj, "$Type", "")]
	caption := trim_space(object.get(obj, "Caption", ""))
	count(caption) == 0

	error := sprintf(
		"[%v, %v, %v] Microflow %v has a split without a caption",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
			input.Name,
		],
	)
}
