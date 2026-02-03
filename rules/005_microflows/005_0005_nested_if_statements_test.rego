package app.mendix.microflows.nested_if_statements_test

import data.app.mendix.microflows.nested_if_statements
import rego.v1

# Test data
one_exclusive_split_with_no_nested_ifs := {"ObjectCollection": {
	"$Type": "Microflows$MicroflowObjectCollection",
	"Objects": [{
		"$Type": "Microflows$ExpressionSplitCondition",
		"Caption": "no nested ifs",
		"SplitCondition": {"Expression": "if $Variable then a else b"},
	}],
}}

multiple_exclusive_splits_with_no_nested_ifs := {"ObjectCollection": {
	"$Type": "Microflows$MicroflowObjectCollection",
	"Objects": [
		{
			"$Type": "Microflows$ExpressionSplitCondition",
			"Caption": "ex spit 1 with no nested ifs",
			"SplitCondition": {"Expression": "if $Variable then a else b"},
		},
		{
			"$Type": "Microflows$ExpressionSplitCondition",
			"Caption": "ex split 2 with no nested ifs",
			"SplitCondition": {"Expression": "if $Variable then c else d"},
		},
	],
}}

one_exclusive_split_with_else_if := {"ObjectCollection": {
	"$Type": "Microflows$MicroflowObjectCollection",
	"Objects": [{
		"$Type": "Microflows$ExclusiveSplit",
		"Caption": "ex split with else-if",
		"SplitCondition": {"Expression": "if true then\n\tfalse\nelse if false then\n\ttrue\nelse false"},
	}],
}}

one_exclusive_split_with_then_if := {"ObjectCollection": {
	"$Type": "Microflows$MicroflowObjectCollection",
	"Objects": [{
		"$Type": "Microflows$ExclusiveSplit",
		"Caption": "ex split with then-if",
		"SplitCondition": {"Expression": "if a then if b then c else d else e"},
	}],
}}

multiple_exclusive_splits_with_one_nested_if := {"ObjectCollection": {
	"$Type": "Microflows$MicroflowObjectCollection",
	"Objects": [
		{
			"$Type": "Microflows$ExclusiveSplit",
			"Caption": "no nested ifs",
			"SplitCondition": {"Expression": "if $Variable then a else b"},
		},
		{
			"$Type": "Microflows$ExclusiveSplit",
			"Caption": "ex split with then-if",
			"SplitCondition": {"Expression": "if a then b else if c then d else e"},
		},
	],
}}

# Test cases
test_should_allow_when_no_exclusive_splits_with_nested_ifs if {
	nested_if_statements.allow with input as one_exclusive_split_with_no_nested_ifs
	nested_if_statements.allow with input as multiple_exclusive_splits_with_no_nested_ifs
}

test_should_deny_when_exclusive_splits_with_nested_ifs if {
	not nested_if_statements.allow with input as one_exclusive_split_with_else_if
	not nested_if_statements.allow with input as one_exclusive_split_with_then_if
	not nested_if_statements.allow with input as multiple_exclusive_splits_with_one_nested_if
}
