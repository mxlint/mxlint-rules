# METADATA
# scope: package
# title: Avoid using default read write access
# description: This can lead to wrong set access rights
# authors:
# - Jurre Tanja <jurre.tanja@mendix.com>
# - Bart Zantingh <bart.zantingh@nl.abnamro.com>
# related_resources:
# - https://docs.mendix.com/refguide/access-rules/
# - https://docs.mendix.com/refguide/dev-best-practices/#security
# custom:
#  category: Maintainability
#  rulename: AvoidDefaultReadWriteAccess
#  severity: MEDIUM
#  rulenumber: 002_0008
#  remediation: Set default access rights to Read only or None.
#  input: .*/DomainModels\$DomainModel\.yaml
package app.mendix.domain_model.avoid_default_readwrite_access

import rego.v1

annotation := rego.metadata.chain()[1].annotations

default allow := false

allow if count(errors) == 0

errors contains error if {
	some entity in input.Entities
	entity_name := entity.Name

	# Bind the specific access rule we are evaluating
	some access_rule in entity.AccessRules

	# Only consider access rules with ReadWrite default rights
	access_rule.DefaultMemberAccessRights == "ReadWrite"

	# Now collect roles only from THIS access_rule
	roles := access_rule.AllowedModuleRoles

	role_names := [name |
		some role in roles
		name := split(role, ".")[1]
	]

	roles_list := concat(", ", role_names)

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
