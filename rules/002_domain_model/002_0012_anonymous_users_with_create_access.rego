# METADATA
# scope: package
# title: Anonymous users should not be allowed to create persistent entities
# description: Anonymous users with create access to persistent entities can pose security risks
# authors:
# - Bart Zantingh <bart.zantingh@nl.abnamro.com>
# custom:
#  category: Security
#  rulename: AnonymousUsersWithCreateAccess
#  severity: HIGH
#  rulenumber: "002_0012"
#  remediation: Remove create access or make entity non-persistent
#  input: "*/DomainModels$DomainModel.yaml"
package app.mendix.domain_model.anonymous_users_with_create_access

import rego.v1

annotation := rego.metadata.chain()[1].annotations

default allow := false

allow if count(errors) == 0

errors contains error if {
	some entity in input.Entities
	entity.MaybeGeneralization.Persistable == true
	entity_name := entity.Name

	some access_rule in entity.AccessRules
	access_rule.AllowCreate == true

	some module_role in access_rule.AllowedModuleRoles
	contains(lower(module_role), "anon") # converts module role name to lower case so it catches all variants of spelling

	module_name := split(module_role, ".")[0]
	module_role_name := split(module_role, ".")[1]

	error := sprintf(
		"[%v, %v, %v] Module role %v in module %v seems to be for anonymous users, but has Create access to persistent entity %v",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
			module_role_name,
			module_name,
			entity_name,
		],
	)
}
