package app.mendix.domain_model.unlimited_length_attributes_editable_by_anonymous_test

import data.app.mendix.domain_model.unlimited_length_attributes_editable_by_anonymous
import rego.v1

# Test data
anon_with_readonly_access := {"Entities": [{
	"AccessRules": [{
		"AllowedModuleRoles": ["MxLintTest.Anonymous"],
		"MemberAccesses": [{
			"$Type": "DomainModels$MemberAccess",
			"AccessRights": "ReadOnly",
			"Attribute": "MxLintTest.TestEntity.Attribute",
		}],
	}],
	"Attributes": [{
		"$Type": "DomainModels$Attribute",
		"Name": "Attribute",
		"NewType": {
			"$Type": "DomainModels$StringAttributeType",
			"Length": 0,
		},
	}],
	"Name": "TestEntity",
}]}

anon_with_readwrite_access := {"Entities": [{
	"AccessRules": [{
		"AllowedModuleRoles": ["MxLintTest.Anonymous"],
		"MemberAccesses": [{
			"$Type": "DomainModels$MemberAccess",
			"AccessRights": "ReadWrite",
			"Attribute": "MxLintTest.TestEntity.Attribute",
		}],
	}],
	"Attributes": [{
		"$Type": "DomainModels$Attribute",
		"Name": "Attribute",
		"NewType": {
			"$Type": "DomainModels$StringAttributeType",
			"Length": 0,
		},
	}],
	"Name": "TestEntity",
}]}

# Test cases
test_should_allow_when_anon_has_readonly_access if {
	unlimited_length_attributes_editable_by_anonymous.allow with input as anon_with_readonly_access
}

test_should_deny_when_anon_has_readwrite_access if {
	not unlimited_length_attributes_editable_by_anonymous.allow with input as anon_with_readwrite_access
}
