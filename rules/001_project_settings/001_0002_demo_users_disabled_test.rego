package app.mendix.project_settings.demo_users_disabled_test

import data.app.mendix.project_settings.demo_users_disabled
import rego.v1

# Test cases
test_allow if {
	demo_users_disabled.allow with input as {"EnableDemoUsers": false}
}

test_no_allow if {
	not demo_users_disabled.allow with input as {"EnableDemoUsers": true}
}
