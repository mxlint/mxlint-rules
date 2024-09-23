package app.mendix.project_settings.anonymous_disabled_test

import data.app.mendix.project_settings.anonymous_disabled
import rego.v1

# Test cases
test_allow if {
	anonymous_disabled.allow with input as {"EnableGuestAccess": false}
}

test_no_allow if {
	not anonymous_disabled.allow with input as {"EnableGuestAccess": true}
}
