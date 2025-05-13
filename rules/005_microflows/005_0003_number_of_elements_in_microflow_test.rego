package app.mendix.microflows.number_of_elements_in_microflow_test

import data.app.mendix.microflows.number_of_elements_in_microflow
import rego.v1

# Test data
microflow_with_less_than_25_activities := {
	"$Type": "Microflows$Microflow",
	"Name": "Microflow_with_less_than_25_activities",
	"ObjectCollection": {
		"$Type": "Microflows$MicroflowObjectCollection",
		"Objects": [
			{"$Type": "Microflows$StartEvent"},
			{"$Type": "Microflows$EndEvent"},
			{"$Type": "Microflows$ActionActivity"},
		],
	},
}

microflow_with_more_than_25_activities := {
	"$Type": "Microflows$Microflow",
	"Name": "Microflow_with_more_than_25_activities",
	"ObjectCollection": {
		"$Type": "Microflows$MicroflowObjectCollection",
		"Objects": [
			{"$Type": "Microflows$StartEvent"},
			{"$Type": "Microflows$EndEvent"},
			{"$Type": "Microflows$ActionActivity"},
			{"$Type": "Microflows$ActionActivity"},
			{"$Type": "Microflows$ActionActivity"},
			{"$Type": "Microflows$ActionActivity"},
			{"$Type": "Microflows$ActionActivity"},
			{"$Type": "Microflows$ActionActivity"},
			{"$Type": "Microflows$ActionActivity"},
			{"$Type": "Microflows$ActionActivity"},
			{"$Type": "Microflows$ActionActivity"},
			{"$Type": "Microflows$ActionActivity"},
			{"$Type": "Microflows$ActionActivity"},
			{"$Type": "Microflows$ActionActivity"},
			{"$Type": "Microflows$ActionActivity"},
			{"$Type": "Microflows$ActionActivity"},
			{"$Type": "Microflows$ActionActivity"},
			{"$Type": "Microflows$ActionActivity"},
			{"$Type": "Microflows$ActionActivity"},
			{"$Type": "Microflows$ActionActivity"},
			{"$Type": "Microflows$ActionActivity"},
			{"$Type": "Microflows$ActionActivity"},
			{"$Type": "Microflows$ActionActivity"},
			{"$Type": "Microflows$ActionActivity"},
			{"$Type": "Microflows$ActionActivity"},
			{"$Type": "Microflows$ActionActivity"},
			{"$Type": "Microflows$ActionActivity"},
			{"$Type": "Microflows$ActionActivity"},
		],
	},
}

# Test cases
test_should_allow_when_microflow_has_less_than_25_activities if {
	number_of_elements_in_microflow.allow with input as microflow_with_less_than_25_activities
}

test_should_deny_when_microflow_has_more_than_25_activities if {
	not number_of_elements_in_microflow.allow with input as microflow_with_more_than_25_activities
}
