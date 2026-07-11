# METADATA
# scope: package
# title: Avoid nested loops in a microflow
# description: A loop can potentially be executed hundreds or thousands of times. A loop inside a loop multiplies that cost and quickly leads to performance problems.
# authors:
# - Xiwen Cheng <x@cinaq.com>
# related_resources:
# - https://sdf-docs.clevr.com/?docs=acr-rules/performance/loopinloop
# custom:
#  category: Performance
#  rulename: LoopInLoop
#  severity: MEDIUM
#  rulenumber: "005_0007"
#  remediation: Restructure the logic to avoid nesting loops, for example by retrieving the required data once before the outer loop.
#  input: "**/*$Microflow.yaml"
package app.mendix.microflows.loop_in_loop

import rego.v1

annotation := rego.metadata.chain()[1].annotations

default allow := false

allow if count(errors) == 0

errors contains error if {
	# Find a loop that contains another loop anywhere within its body.
	some outer
	walk(input, [_, outer])
	outer["$Type"] == "Microflows$LoopedActivity"

	some inner
	walk(outer.ObjectCollection, [_, inner])
	inner["$Type"] == "Microflows$LoopedActivity"

	error := sprintf(
		"[%v, %v, %v] Microflow %v contains a loop nested inside another loop",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
			input.Name,
		],
	)
}
