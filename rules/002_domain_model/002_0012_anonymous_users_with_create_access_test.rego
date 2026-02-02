package app.mendix.domain_model.anonymous_users_with_create_access_test

import data.app.mendix.domain_model.anonymous_users_with_create_access
import rego.v1

# Test data
anon_role_with_create_access_to_persistent := {
	"$Type": "DomainModels$DomainModel",
	"Entities": [{
		"AccessRules": [{
			"AllowCreate": true,
			"AllowedModuleRoles": ["MyFirstModule.Anonymous"],
		}],
		"MaybeGeneralization": {"Persistable": true},
		"Name": "Entity",
	}],
}

anon_role_without_create_access_to_persistent := {
	"$Type": "DomainModels$DomainModel",
	"Entities": [{
		"AccessRules": [{
			"AllowCreate": false,
			"AllowedModuleRoles": ["MyFirstModule.Anonymous"],
		}],
		"MaybeGeneralization": {"Persistable": true},
		"Name": "Entity",
	}],
}

anon_role_with_create_access_to_nonpersistent := {
	"$Type": "DomainModels$DomainModel",
	"Entities": [{
		"AccessRules": [{
			"AllowCreate": true,
			"AllowedModuleRoles": ["MyFirstModule.Anonymous"],
		}],
		"MaybeGeneralization": {"Persistable": false},
		"Name": "Entity",
	}],
}

# Test cases
test_should_allow_when_anon_role_has_no_create_access_to_persistent_entity if {
	anonymous_users_with_create_access.allow with input as anon_role_without_create_access_to_persistent
}

test_should_allow_when_anon_role_has_create_access_to_nonpersistent_entity if {
	anonymous_users_with_create_access.allow with input as anon_role_with_create_access_to_nonpersistent
}

test_should_deny_when_anon_role_has_create_access_to_persistent_entity if {
	not anonymous_users_with_create_access.allow with input as anon_role_with_create_access_to_persistent
}
