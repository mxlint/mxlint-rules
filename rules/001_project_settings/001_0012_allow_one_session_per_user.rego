# METADATA
# scope: package
# title: Allow only one session per user
# description: Allowing multiple concurrent sessions per user increases the attack surface and makes it harder to invalidate a session. Restrict users to a single active session unless there is a clear business reason.
# authors:
# - Xiwen Cheng <x@cinaq.com>
# related_resources:
# - https://sdf-docs.clevr.com/?docs=acr-rules/security/securityallowonesessionperuser
# custom:
#  category: Security
#  rulename: AllowOneSessionPerUser
#  severity: MEDIUM
#  rulenumber: "001_0012"
#  remediation: Disable "Allow multiple sessions per user" in the project runtime settings.
#  input: .*Settings\$ProjectSettings\.yaml
package app.mendix.project_settings.allow_one_session_per_user

import rego.v1

annotation := rego.metadata.chain()[1].annotations

default allow := false

allow if count(errors) == 0

errors contains error if {
	some part in input.Settings
	part["$Type"] == "Settings$ModelSettings"
	part.AllowUserMultipleSessions == true

	error := sprintf(
		"[%v, %v, %v] Multiple sessions per user are allowed",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
		],
	)
}
