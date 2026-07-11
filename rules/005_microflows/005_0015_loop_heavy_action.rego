# METADATA
# scope: package
# title: Avoid heavy actions inside a loop
# description: A loop can run hundreds or thousands of times. Performing heavy actions such as database retrieves, microflow calls or web service calls inside a loop multiplies their cost and quickly leads to performance problems.
# authors:
# - Xiwen Cheng <x@cinaq.com>
# related_resources:
# - https://sdf-docs.clevr.com/?docs=acr-rules/performance/loopheavyaction
# custom:
#  category: Performance
#  rulename: LoopHeavyAction
#  severity: MEDIUM
#  rulenumber: "005_0015"
#  remediation: Move the heavy action out of the loop, for example by retrieving all required data once before the loop.
#  input: "**/*$Microflow.yaml"
package app.mendix.microflows.loop_heavy_action

import rego.v1

annotation := rego.metadata.chain()[1].annotations

heavy_actions := {
	"Microflows$RetrieveAction",
	"Microflows$MicroflowCallAction",
	"Microflows$DeleteAction",
	"Microflows$AggregateListAction",
	"Microflows$RestCallAction",
	"Microflows$WebServiceCallAction",
	"Microflows$ImportMappingAction",
	"Microflows$ExportMappingAction",
}

default allow := false

allow if count(errors) == 0

errors contains error if {
	some loop
	walk(input, [_, loop])
	loop["$Type"] == "Microflows$LoopedActivity"

	some obj
	walk(loop.ObjectCollection, [_, obj])
	heavy_actions[object.get(obj, "$Type", "")]

	error := sprintf(
		"[%v, %v, %v] Microflow %v performs a heavy action (%v) inside a loop",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
			input.Name,
			obj["$Type"],
		],
	)
}
