package app.mendix.project_settings.mxadmin_userid
import rego.v1

# Test cases
test_allow if {
	allow with input as {"AdminUserName": "SystemAdmin"}
}
test_no_allow if {
	not allow with input as {"AdminUserName": "MxAdmin"}
}