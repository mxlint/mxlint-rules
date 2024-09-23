package app.mendix.domain_model.avoid_system_entity_association_test

import data.app.mendix.domain_model.avoid_system_entity_association
import rego.v1

# Test data
negative := {
	"Name": "HELLO_THERE1",
	"Child": "SomeModule.FileDocument",
}

positive := {
	"Name": "HELLO_THERE2",
	"Child": "System.FileDocument",
}

# Test cases

test_no_cross_associations if {
	avoid_system_entity_association.allow with input as {"CrossAssociations": null}
}

test_negative if {
	avoid_system_entity_association.allow with input as {"CrossAssociations": [negative]}
}

test_positive if {
	not avoid_system_entity_association.allow with input as {"CrossAssociations": [positive]}
}

test_mixed if {
	not avoid_system_entity_association.allow with input as {"CrossAssociations": [negative, positive]}
}
