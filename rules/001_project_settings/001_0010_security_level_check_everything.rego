# METADATA
# scope: package
# title: Security level should be set to production
# description: The project security level should be "CheckEverything" so that both page and microflow access as well as entity access are enforced. Lower levels leave parts of the app unprotected.
# authors:
# - Xiwen Cheng <x@cinaq.com>
# related_resources:
# - https://sdf-docs.clevr.com/?docs=acr-rules/security/securitylevel
# custom:
#  category: Security
#  rulename: SecurityLevelCheckEverything
#  severity: HIGH
#  rulenumber: "001_0010"
#  remediation: Set the security level to "CheckEverything" in the project security settings.
#  input: .*Security\$ProjectSecurity\.yaml
package app.mendix.project_settings.security_level_check_everything

import rego.v1

annotation := rego.metadata.chain()[1].annotations

default allow := false

allow if count(errors) == 0

errors contains error if {
	input.SecurityLevel != "CheckEverything"

	error := sprintf(
		"[%v, %v, %v] Security level is %v, expected CheckEverything",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
			input.SecurityLevel,
		],
	)
}
