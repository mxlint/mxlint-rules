# METADATA
# scope: package
# title: Exposed constants with sensitive data
# description: Constants with potentially sensitive data should not be exposed to the client.
# authors:
# - Bart Zantingh <bart.zantingh@nl.abnamro.com>
# custom:
#  category: Security
#  rulename: ExposedConstants
#  severity: HIGH
#  rulenumber: "006_0001"
#  remediation: Set constant's 'Exposed to client' setting to false.
#  input: "**/*$Constant.yaml"
package app.mendix.constants.exposed_constants

import rego.v1

annotation := rego.metadata.chain()[1].annotations

default allow := false

allow if count(errors) == 0

exposed := input.ExposedToClient

errors contains error if {
	exposed

	name := input.Name

	error := sprintf(
		"[%v, %v, %v] Constant %v is exposed to the client",
		[
			"MEDIUM",
			annotation.custom.category,
			annotation.custom.rulenumber,
			name,
		],
	)
}

errors contains error if {
	contains_sensitive_data
	exposed

	name := input.Name

	error := sprintf(
		"[%v, %v, %v] Constant %v is exposed to the client, and seems to contain sensitive data",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
			name,
		],
	)
}

sensitive_keywords := [
	"id", "ident",
	"username", "user_name", "user", "usr", "uname",
	"secret", "scrt",
	"password", "pwd", "passwrd",
]

contains_sensitive_data if {
	some keyword in sensitive_keywords
	contains(lower(input.Name), keyword)
}
