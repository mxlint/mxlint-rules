# METADATA
# scope: package
# title: Limit the number of module roles per module
# description: A module with many module roles increases the complexity of the security model. Keep the number of module roles per module small and map them to user roles at the project level.
# authors:
# - Xiwen Cheng <x@cinaq.com>
# related_resources:
# - https://sdf-docs.clevr.com/?docs=acr-rules/maintainability/modulerolesamount
# custom:
#  category: Maintainability
#  rulename: ModuleRolesAmount
#  severity: LOW
#  rulenumber: "006_0002"
#  remediation: Reduce the number of module roles by combining roles that share the same access, or move variation to the user-role level.
#  input: .*Security\$ModuleSecurity\.yaml
package app.mendix.security.module_roles_amount

import rego.v1

annotation := rego.metadata.chain()[1].annotations

max_module_roles := 5

default allow := false

allow if count(errors) == 0

module_role_count := count(object.get(input, "ModuleRoles", []))

errors contains error if {
	module_role_count > max_module_roles

	error := sprintf(
		"[%v, %v, %v] Module has %v module roles, which exceeds the maximum of %v",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
			module_role_count,
			max_module_roles,
		],
	)
}
