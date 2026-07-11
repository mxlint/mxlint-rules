# METADATA
# scope: package
# title: Microflow should not call itself (recursion)
# description: Recursion is a complex structure and Mendix has no built-in fail-safe. A wrong exit condition or bad data can keep the recursive calls going and crash the app.
# authors:
# - Xiwen Cheng <x@cinaq.com>
# related_resources:
# - https://sdf-docs.clevr.com/?docs=acr-rules/architecture/microflowcallsself
# custom:
#  category: Architecture
#  rulename: MicroflowCallsSelf
#  severity: MEDIUM
#  rulenumber: "005_0006"
#  remediation: Avoid recursion. If it is truly needed, add an emergency brake that stops execution after a maximum number of iterations.
#  input: "**/*$Microflow.yaml"
package app.mendix.microflows.microflow_calls_self

import rego.v1

annotation := rego.metadata.chain()[1].annotations

default allow := false

allow if count(errors) == 0

errors contains error if {
	# A microflow call anywhere in the flow (including inside loops) that
	# targets a microflow with the same short name is a self-call / recursion.
	some obj
	walk(input, [_, obj])
	obj["$Type"] == "Microflows$MicroflowCallAction"
	endswith(obj.MicroflowCall.Microflow, sprintf(".%v", [input.Name]))

	error := sprintf(
		"[%v, %v, %v] Microflow %v calls itself (recursion)",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
			input.Name,
		],
	)
}
