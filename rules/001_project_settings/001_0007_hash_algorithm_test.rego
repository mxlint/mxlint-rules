package app.mendix.project_settings.hash_algorithm_test

import data.app.mendix.project_settings.hash_algorithm
import rego.v1

# Test data
bcrypt := {"Settings": {
	"$Type": "Settings$ModelSettings",
	"HashAlgorithm": "BCrypt",
}}

ssha256 := {"Settings": {
	"$Type": "Settings$ModelSettings",
	"HashAlgorithm": "SSHA256",
}}

sha256 := {"Settings": {
	"$Type": "Settings$ModelSettings",
	"HashAlgorithm": "SHA256",
}}

md5 := {"Settings": {
	"$Type": "Settings$ModelSettings",
	"HashAlgorithm": "MD5",
}}

# Test cases
test_should_allow_when_build_version_in_allowed_list if {
	hash_algorithm.allow with input as bcrypt
	hash_algorithm.allow with input as ssha256
}

test_should_deny_when_build_version_not_in_allowed_list if {
	not hash_algorithm.allow with input as sha256
	not hash_algorithm.allow with input as md5
}
