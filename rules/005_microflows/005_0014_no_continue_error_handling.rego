# METADATA
# scope: package
# title: Do not silently continue on errors
# description: An activity with "Continue" error handling completely ignores the error. At the very least the error should be logged and handled, otherwise failures pass by unnoticed.
# authors:
# - Xiwen Cheng <x@cinaq.com>
# related_resources:
# - https://sdf-docs.clevr.com/?docs=acr-rules/maintainability/nocontinues
# - https://docs.mendix.com/howto/logic-business-rules/set-up-error-handling
# custom:
#  category: Maintainability
#  rulename: NoContinueErrorHandling
#  severity: MEDIUM
#  rulenumber: "005_0014"
#  remediation: Use custom error handling that at least logs the error, instead of continuing silently.
#  input: "**/*$Microflow.yaml"
package app.mendix.microflows.no_continue_error_handling

import rego.v1

annotation := rego.metadata.chain()[1].annotations

default allow := false

allow if count(errors) == 0

errors contains error if {
	some obj
	walk(input, [_, obj])
	object.get(obj, "ErrorHandlingType", "") == "Continue"

	error := sprintf(
		"[%v, %v, %v] Microflow %v has an activity that continues on error without handling it",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
			input.Name,
		],
	)
}
