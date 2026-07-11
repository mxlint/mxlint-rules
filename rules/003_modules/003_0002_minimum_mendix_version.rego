# METADATA
# scope: package
# title: Use a supported Mendix major version
# description: Older Mendix major versions no longer receive security patches or bug fixes. Running on an unsupported major version (for example 5, 6 or 7) is a maintainability and security risk.
# authors:
# - Xiwen Cheng <x@cinaq.com>
# related_resources:
# - https://sdf-docs.clevr.com/?docs=acr-rules/maintainability/latestmendixverion
# custom:
#  category: Maintainability
#  rulename: MinimumMendixVersion
#  severity: MEDIUM
#  rulenumber: "003_0002"
#  remediation: Upgrade the app to a currently supported Mendix major version.
#  input: .*Metadata\.yaml
package app.mendix.modules.minimum_mendix_version

import rego.v1

annotation := rego.metadata.chain()[1].annotations

minimum_major := 9

default allow := false

allow if count(errors) == 0

major_version := to_number(split(input.ProductVersion, ".")[0])

errors contains error if {
	major_version < minimum_major

	error := sprintf(
		"[%v, %v, %v] Mendix major version %v is below the minimum supported version %v",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
			major_version,
			minimum_major,
		],
	)
}
