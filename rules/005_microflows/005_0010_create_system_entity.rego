# METADATA
# scope: package
# title: Avoid creating System entities directly
# description: System entities such as User or Session should not be instantiated directly in a microflow. Create an Administration.Account instead and let Mendix manage sessions.
# authors:
# - Xiwen Cheng <x@cinaq.com>
# related_resources:
# - https://sdf-docs.clevr.com/?docs=acr-rules/reliability/createsystementity
# custom:
#  category: Reliability
#  rulename: CreateSystemEntity
#  severity: MEDIUM
#  rulenumber: "005_0010"
#  remediation: Create an Administration.Account (which specializes System.User) instead of creating a System entity directly, and let Mendix handle session creation.
#  input: "**/*$Microflow.yaml"
package app.mendix.microflows.create_system_entity

import rego.v1

annotation := rego.metadata.chain()[1].annotations

default allow := false

allow if count(errors) == 0

errors contains error if {
	# Find any create action (anywhere in the flow) that instantiates a System entity.
	some obj
	walk(input, [_, obj])
	startswith(object.get(obj, "$Type", ""), "Microflows$Create")
	startswith(object.get(obj, "Entity", ""), "System.")

	error := sprintf(
		"[%v, %v, %v] Microflow %v creates System entity %v directly",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
			input.Name,
			obj.Entity,
		],
	)
}
