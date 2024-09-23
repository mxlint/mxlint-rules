package app.mendix.domain_model.number_of_entities_test

import data.app.mendix.domain_model.number_of_entities
import rego.v1

# Test data
entity_attr_0 := {"Name": "Entity1"}

twenty := numbers.range(1, 20)

entities_20 := [
{"Name": entity_attr_0.Name} | n := twenty[_]]

# Test cases

test_no_entities if {
	number_of_entities.allow with input as {"Entities": null}
}

test_1_entity if {
	number_of_entities.allow with input as {"Entities": [entity_attr_0]}
}

test_2_entities if {
	number_of_entities.allow with input as {"Entities": [entity_attr_0, entity_attr_0]}
}

test_20_entities if {
	not number_of_entities.allow with input as {"Entities": entities_20}
}
