package app.mendix.microflows.empty_string_check_not_complete_test

import data.app.mendix.microflows.empty_string_check_not_complete
import rego.v1

# Test data
microflow_good := {
	"$Type": "Microflow$Page",
	"Name": "mf1",
	"ObjectCollection": {
		"$Type": "Microflows$MicroflowObjectCollection",
		"Objects": [{
			"$Type": "Microflows$ExclusiveSplit",
			"SplitCondition": {
				"$Type": "Microflows$ExpressionSplitCondition",
				"Expression": "$Variable != empty and $Variable != ''",
			},
		}],
	},
}

microflow_bad := {
	"$Type": "Microflow$Page",
	"Name": "mf1",
	"ObjectCollection": {
		"$Type": "Microflows$MicroflowObjectCollection",
		"Objects": [{
			"$Type": "Microflows$ExclusiveSplit",
			"SplitCondition": {
				"$Type": "Microflows$ExpressionSplitCondition",
				"Expression": "$Variable != ''",
			},
		}],
	},
}

# Test cases
test_simple if {
	empty_string_check_not_complete.allow with input as microflow_good
}

test_simple_negative if {
	not empty_string_check_not_complete.allow with input as microflow_bad
}
