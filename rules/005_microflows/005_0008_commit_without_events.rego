# METADATA
# scope: package
# title: Avoid committing without events
# description: There is rarely a reason to disable events during a commit. Disabling them silently skips before/after commit logic and should only be done with a very good justification.
# authors:
# - Xiwen Cheng <x@cinaq.com>
# related_resources:
# - https://sdf-docs.clevr.com/?docs=acr-rules/reliability/commitwithoutevents
# custom:
#  category: Reliability
#  rulename: CommitWithoutEvents
#  severity: MEDIUM
#  rulenumber: "005_0008"
#  remediation: Commit with events enabled, or document why the events must be skipped.
#  input: "**/*$Microflow.yaml"
package app.mendix.microflows.commit_without_events

import rego.v1

annotation := rego.metadata.chain()[1].annotations

default allow := false

allow if count(errors) == 0

# Dedicated Commit action with events explicitly disabled.
errors contains error if {
	some obj
	walk(input, [_, obj])
	obj["$Type"] == "Microflows$CommitAction"
	obj.WithEvents == false

	error := sprintf(
		"[%v, %v, %v] Commit action in microflow %v is configured without events",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
			input.Name,
		],
	)
}

# Change action that commits without events.
errors contains error if {
	some obj
	walk(input, [_, obj])
	obj["$Type"] == "Microflows$ChangeAction"
	obj.Commit == "YesWithoutEvents"

	error := sprintf(
		"[%v, %v, %v] Change action in microflow %v commits without events",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
			input.Name,
		],
	)
}
