# METADATA
# scope: package
# title: Strict page URL check should be enabled
# description: With strict page URL check enabled, pages can only be opened through a valid navigation path, which prevents users from reaching pages they should not have direct access to.
# authors:
# - Xiwen Cheng <x@cinaq.com>
# related_resources:
# - https://sdf-docs.clevr.com/?docs=acr-rules/security/securitystrictpageurl
# custom:
#  category: Security
#  rulename: StrictPageUrlCheck
#  severity: MEDIUM
#  rulenumber: "001_0011"
#  remediation: Enable "Strict page URL check" in the project security settings.
#  input: .*Security\$ProjectSecurity\.yaml
package app.mendix.project_settings.strict_page_url_check

import rego.v1

annotation := rego.metadata.chain()[1].annotations

default allow := false

allow if count(errors) == 0

errors contains error if {
	input.StrictPageUrlCheck == false

	error := sprintf(
		"[%v, %v, %v] Strict page URL check is disabled",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
		],
	)
}
