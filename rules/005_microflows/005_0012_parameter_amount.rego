# METADATA
# scope: package
# title: Limit the number of microflow parameters
# description: A microflow with many parameters is harder to understand, reuse and test. Consider passing an object or splitting the logic when the number of parameters grows too large.
# authors:
# - Xiwen Cheng <x@cinaq.com>
# related_resources:
# - https://sdf-docs.clevr.com/?docs=acr-rules/maintainability/parameteramount
# custom:
#  category: Maintainability
#  rulename: ParameterAmount
#  severity: LOW
#  rulenumber: "005_0012"
#  remediation: Reduce the number of parameters, for example by passing a single object that groups related values.
#  input: "**/*$Microflow.yaml"
package app.mendix.microflows.parameter_amount

import rego.v1

annotation := rego.metadata.chain()[1].annotations

max_parameters := 5

default allow := false

allow if count(errors) == 0

parameter_count := count([obj |
	some obj in input.ObjectCollection.Objects
	obj["$Type"] == "Microflows$MicroflowParameter"
])

errors contains error if {
	parameter_count > max_parameters

	error := sprintf(
		"[%v, %v, %v] Microflow %v has %v parameters, which exceeds the maximum of %v",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
			input.Name,
			parameter_count,
			max_parameters,
		],
	)
}
