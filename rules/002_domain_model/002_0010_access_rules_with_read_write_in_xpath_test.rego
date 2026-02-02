package app.mendix.domain_model.access_rules_with_read_write_in_xpath_test

import data.app.mendix.domain_model.access_rules_with_read_write_in_xpath
import rego.v1

# Test data
attribute_with_read_used_in_xpath := {"Entities": [{
	"AccessRules": [{
		"MemberAccesses": [{
			"AccessRights": "Read",
			"Attribute": "MxLintTest.TestEntity.Attribute1",
			"Association": "",
		}],
		"XPathConstraint": "[Attribute1 = true]",
	}],
	"Attributes": [{
		"$Type": "DomainModels$Attribute",
		"Name": "Attribute1",
	}],
	"Name": "TestEntity",
}]}

attribute_with_read_write_used_in_xpath := {"Entities": [{
	"AccessRules": [{
		"MemberAccesses": [{
			"AccessRights": "ReadWrite",
			"Attribute": "MxLintTest.TestEntity.Attribute1",
			"Association": "",
		}],
		"XPathConstraint": "[Attribute1 = true]",
	}],
	"Attributes": [{
		"$Type": "DomainModels$Attribute",
		"Name": "Attribute1",
	}],
	"Name": "TestEntity",
}]}

association_with_read_used_in_xpath := {
	"Associations": [{"Name": "TestEntity_Entity"}],
	"Entities": [{
		"AccessRules": [{
			"MemberAccesses": [{
				"AccessRights": "Read",
				"Attribute": "",
				"Association": "MxLintTest.TestEntity_Entity",
			}],
			"XPathConstraint": "[MxLintTest.TestEntity_Entity/MxLintTest.Entity]",
		}],
		"Name": "TestEntity",
	}],
}

association_with_read_write_used_in_xpath := {
	"Associations": [{"Name": "TestEntity_Entity"}],
	"Entities": [{
		"AccessRules": [{
			"MemberAccesses": [{
				"AccessRights": "ReadWrite",
				"Attribute": "",
				"Association": "MxLintTest.TestEntity_Entity",
			}],
			"XPathConstraint": "[MxLintTest.TestEntity_Entity/MxLintTest.Entity]",
		}],
		"Name": "TestEntity",
	}],
}

# Test cases
test_should_allow_when_default_access_rights_none_or_read if {
	access_rules_with_read_write_in_xpath.allow with input as attribute_with_read_used_in_xpath
	access_rules_with_read_write_in_xpath.allow with input as association_with_read_used_in_xpath
}

test_should_deny_when_attribute_with_read_write_in_xpath if {
	not access_rules_with_read_write_in_xpath.allow with input as attribute_with_read_write_used_in_xpath
}

test_should_deny_when_association_with_read_write_in_xpath if {
	not access_rules_with_read_write_in_xpath.allow with input as association_with_read_write_used_in_xpath
}
