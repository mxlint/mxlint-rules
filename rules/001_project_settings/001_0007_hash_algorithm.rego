# METADATA
# scope: package
# title: Hash algorithm
# description: Hashs algorithms BCrypt and SSHA256 are considered to be the safest for data encryption.
# authors:
# - Bart Zantingh <bart.zantingh@nl.abnamro.com>
# related_resources:
# - https://docs.mendix.com/refguide/security#hashing-algorithms
# custom:
#  category: Security
#  rulename: HashAlgorithm
#  severity: HIGH
#  rulenumber: "001_0007"
#  remediation: Set the app's hash algorithm (App Settings > Runtime) to BCrypt or SSHA256.
#  input: "Settings$ProjectSettings.yaml"
package app.mendix.project_settings.hash_algorithm

import rego.v1

annotation := rego.metadata.chain()[1].annotations

default allow := false

allow if count(errors) == 0

errors contains error if {
	not input.Settings.HashAlgorithm == "BCrypt"
	not input.Settings.HashAlgorithm == "SSHA256"

	error := sprintf(
		"[%v, %v, %v] The application uses the %v hash algorithm, which is not recommended",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
			input.Settings.HashAlgorithm,
		],
	)
}
