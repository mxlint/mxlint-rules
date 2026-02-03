package app.mendix.project_settings.check_security_on_user_roles_test

import data.app.mendix.project_settings.check_security_on_user_roles
import rego.v1

# Test data
check_for_security := {"UserRoles": [{
	"CheckSecurity": true,
	"Name": "Administrator",
}]}

not_check_for_security := {"UserRoles": [{
	"CheckSecurity": false,
	"Name": "Administrator",
}]}

# Test cases
test_should_allow_when_checking_user_roles_for_security if {
	check_security_on_user_roles.allow with input as check_for_security
}

test_should_deny_when_not_checking_user_roles_for_security if {
	not check_security_on_user_roles.allow with input as not_check_for_security
}
