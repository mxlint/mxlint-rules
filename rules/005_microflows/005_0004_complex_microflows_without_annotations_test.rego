package app.mendix.microflows.complex_microflows_without_annotations_test

import data.app.mendix.microflows.complex_microflows_without_annotations
import rego.v1

# Test data
microflow_with_1_exclusive_split := {
	"$Type": "Microflows$Microflow",
	"Name": "Microflow",
	"ObjectCollection": {
		"$Type": "Microflows$MicroflowObjectCollection",
		"Objects": [
			{"$Type": "Microflows$ExclusiveSplit"}
		],
	},
}

microflow_with_2_actions_and_2_exclusive_splits := {
	"$Type": "Microflows$Microflow",
	"Name": "Microflow",
	"ObjectCollection": {
		"$Type": "Microflows$MicroflowObjectCollection",
		"Objects": [
			{"$Type": "Microflows$ActionActivity"},
			{"$Type": "Microflows$ActionActivity"},
			{"$Type": "Microflows$ExclusiveSplit"},
			{"$Type": "Microflows$ExclusiveSplit"}
		],
	},
}

microflow_with_11_actions_no_annotations := {
	"$Type": "Microflows$Microflow",
	"Name": "Microflow",
	"ObjectCollection": {
		"$Type": "Microflows$MicroflowObjectCollection",
		"Objects": [
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
			{"$Type": "Microflows$ActionActivity"}
		],
	},
}

microflow_with_11_actions_with_annotations := {
	"$Type": "Microflows$Microflow",
	"Name": "Microflow",
	"ObjectCollection": {
		"$Type": "Microflows$MicroflowObjectCollection",
		"Objects": [
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
			{"$Type": "Microflows$Annotation"}
		],
	},
}

microflow_with_3_exclusive_splits_no_annotations := {
	"$Type": "Microflows$Microflow",
	"Name": "Microflow",
	"ObjectCollection": {
		"$Type": "Microflows$MicroflowObjectCollection",
		"Objects": [
			{"$Type": "Microflows$ExclusiveSplit"},
			{"$Type": "Microflows$ExclusiveSplit"},
			{"$Type": "Microflows$ExclusiveSplit"}
		],
	},
}

microflow_with_3_exclusive_splits_with_annotations := {
	"$Type": "Microflows$Microflow",
	"Name": "Microflow",
	"ObjectCollection": {
		"$Type": "Microflows$MicroflowObjectCollection",
		"Objects": [
			{"$Type": "Microflows$ExclusiveSplit"},
			{"$Type": "Microflows$ExclusiveSplit"},
			{"$Type": "Microflows$ExclusiveSplit"},
			{"$Type": "Microflows$Annotation"}
		],
	},
}

test_should_allow_when_microflow_is_not_complex if {
	complex_microflows_without_annotations.allow with input as microflow_with_2_actions_and_2_exclusive_splits
	complex_microflows_without_annotations.allow with input as microflow_with_1_exclusive_split
}

test_should_allow_when_microflow_is_complex_and_has_annotations if {
	complex_microflows_without_annotations.allow with input as microflow_with_11_actions_with_annotations
	complex_microflows_without_annotations.allow with input as microflow_with_3_exclusive_splits_with_annotations
}

test_should_deny_when_microflow_is_complex_and_has_no_annotations if {
	not complex_microflows_without_annotations.allow with input as microflow_with_11_actions_no_annotations
	not complex_microflows_without_annotations.allow with input as microflow_with_3_exclusive_splits_no_annotations
}
