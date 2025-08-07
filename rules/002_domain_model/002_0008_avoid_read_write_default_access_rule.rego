# METADATA
# scope: package
# title: Avoid using default read write access
# description: This can lead to wrong set access rights
# authors:
# - Jurre Tanja <jurre.tanja@mendix.com>
# custom:
#  category: Maintainability
#  rulename: AvoidDefaultReadWriteAccess
#  severity: MEDIUM
#  rulenumber: 002_0008
#  remediation: Set default access rights to Read only or None.
#  input: .*/DomainModels\$DomainModel\.yaml
package app.mendix.domain_model.avoind_default_readwrite_access

import rego.v1

annotation := rego.metadata.chain()[1].annotations

default allow := false

allow if count(errors) == 0

errors contains error if {
	entity := input.Entities[_]
	entity_name := entity.Name
	roles := entity.AccessRules[_].AllowedModuleRoles
	role_names := [name | role := roles[_]; parts := split(role, "."); name := parts[count(parts) - 1]]
	roles_list := concat(", ", role_names)

	# Check for ReadWrite access
	entity.AccessRules[_].DefaultMemberAccessRights == "ReadWrite"

	error := sprintf(
		"[%v, %v, %v] ReadWrite access rules found in entity %v for roles %v",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
			entity_name,
			roles_list,
		],
	)
}
