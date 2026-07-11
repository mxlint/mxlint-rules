# METADATA
# scope: package
# title: Exposed microflows should apply entity access
# description: A microflow that is directly accessible by end users (it has allowed module roles) and performs database operations should apply entity access, otherwise it can bypass the entity security rules.
# authors:
# - Xiwen Cheng <x@cinaq.com>
# related_resources:
# - https://sdf-docs.clevr.com/?docs=acr-rules/security/microflowentityaccess
# custom:
#  category: Security
#  rulename: MicroflowEntityAccess
#  severity: HIGH
#  rulenumber: "006_0003"
#  remediation: Enable "Apply entity access" on the microflow, or restrict who can call it directly.
#  input: "**/*$Microflow.yaml"
package app.mendix.security.microflow_entity_access

import rego.v1

annotation := rego.metadata.chain()[1].annotations

database_actions := {
	"Microflows$RetrieveAction",
	"Microflows$CreateChangeAction",
	"Microflows$ChangeAction",
	"Microflows$DeleteAction",
	"Microflows$CommitAction",
	"Microflows$RollbackAction",
	"Microflows$AggregateListAction",
}

default allow := false

allow if count(errors) == 0

has_database_action if {
	some obj
	walk(input, [_, obj])
	database_actions[object.get(obj, "$Type", "")]
}

errors contains error if {
	# Directly callable by end users.
	count(object.get(input, "AllowedModuleRoles", [])) > 0

	# Entity access is not applied.
	input.ApplyEntityAccess == false

	# And the microflow touches the database.
	has_database_action

	error := sprintf(
		"[%v, %v, %v] Microflow %v is exposed to module roles but does not apply entity access",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
			input.Name,
		],
	)
}
