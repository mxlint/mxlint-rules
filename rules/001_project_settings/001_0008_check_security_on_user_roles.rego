# METADATA
# scope: package
# title: Check security on user roles
# description: Security should be checked for each user role, to make sure users can only access the minimum amount of data
# authors:
# - Bart Zantingh <bart.zantingh@nl.abnamro.com>
# custom:
#  category: Security
#  rulename: CheckSecurityOnUserRoles
#  severity: HIGH
#  rulenumber: "001_0008"
#  remediation: Check security for all user roles
#  input: "Security$ProjectSecurity.yaml"
package app.mendix.project_settings.check_security_on_user_roles

import rego.v1

annotation := rego.metadata.chain()[1].annotations

default allow := false

allow if count(errors) == 0

errors contains error if {
	some user_role in input.UserRoles
	not user_role.CheckSecurity

	error := sprintf(
		"[%v, %v, %v] User role %v is not checked for security",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
			user_role.Name,
		],
	)
}
