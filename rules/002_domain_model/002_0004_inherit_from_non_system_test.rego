package app.mendix.domain_model.inherit_from_non_system_test

import data.app.mendix.domain_model.inherit_from_non_system
import rego.v1

# Test data
entity_negative := {
	"Name": "Entity1",
	"MaybeGeneralization": {
		"Type": "DomainModels$Generalization",
		"Generalization": "System.FileDocument",
	},
}

entity_positive := {
	"Name": "Entity2",
	"MaybeGeneralization": {
		"Type": "DomainModels$Generalization",
		"Generalization": "Administration.Account",
	},
}

entities_mixed := [entity_negative, entity_positive]

# Test cases
test_no_entities if {
	inherit_from_non_system.allow with input as {"Entities": null}
}

test_entity_negative if {
	inherit_from_non_system.allow with input as {"Entities": [entity_negative]}
}

test_entity_positive if {
	not inherit_from_non_system.allow with input as {"Entities": [entity_positive]}
}

test_entities_mixed if {
	not inherit_from_non_system.allow with input as {"Entities": entities_mixed}
}
