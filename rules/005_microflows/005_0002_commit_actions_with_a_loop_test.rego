package app.mendix.microflows.commit_actions_with_a_loop_test

import data.app.mendix.microflows.commit_actions_with_a_loop
import rego.v1

# Test data
loop_commit_good_empty_objects := {
	"$Type": "Microflow$Microflow",
	"Name": "MicroflowForLoop",
	"MainFunction": [{"Attributes": {
		"$Type": "Microflows$LoopedActivity",
		"ObjectCollection": {
			"$Type": "Microflows$MicroflowObjectCollection",
			"Objects": null,
		},
	}}],
}

loop_commit_good_objects := {
	"$Type": "Microflow$Microflow",
	"Name": "MicroflowForLoop",
	"MainFunction": [{"Attributes": {
		"$Type": "Microflows$LoopedActivity",
		"ObjectCollection": {
			"$Type": "Microflows$MicroflowObjectCollection",
			"Objects": [{
				"$Type": "Microflows$ActionActivity",
				"Action": {
					"$Type": "Microflows$ChangeAction",
					"Commit": "No",
				},
			}],
		},
	}}],
}

loop_commit_bad_commit_action := {
	"$Type": "Microflow$Microflow",
	"Name": "MicroflowForLoop",
	"MainFunction": [{"Attributes": {
		"$Type": "Microflows$LoopedActivity",
		"ObjectCollection": {
			"$Type": "Microflows$MicroflowObjectCollection",
			"Objects": [{
				"$Type": "Microflows$ActionActivity",
				"Action": {"$Type": "Microflows$CommitAction"},
			}],
		},
	}}],
}

loop_commit_bad_change_action := {
	"$Type": "Microflow$Microflow",
	"Name": "MicroflowForLoop",
	"MainFunction": [{"Attributes": {
		"$Type": "Microflows$LoopedActivity",
		"ObjectCollection": {
			"$Type": "Microflows$MicroflowObjectCollection",
			"Objects": [{
				"$Type": "Microflows$ActionActivity",
				"Action": {
					"$Type": "Microflows$ChangeAction",
					"Commit": "Yes",
				},
			}],
		},
	}}],
}

loop_commit_bad_all := {
	"$Type": "Microflow$Microflow",
	"Name": "MicroflowForLoop",
	"MainFunction": [{"Attributes": {
		"$Type": "Microflows$LoopedActivity",
		"ObjectCollection": {
			"$Type": "Microflows$MicroflowObjectCollection",
			"Objects": [
				{
					"$Type": "Microflows$ActionActivity",
					"Action": {"$Type": "Microflows$CommitAction"},
				},
				{
					"$Type": "Microflows$ActionActivity",
					"Action": {
						"$Type": "Microflows$ChangeAction",
						"Commit": "Yes",
					},
				},
			],
		},
	}}],
}

# Test cases
test_loop_commit_good if {
	commit_actions_with_a_loop.allow with input as loop_commit_good_empty_objects
	commit_actions_with_a_loop.allow with input as loop_commit_good_objects
}

test_loop_commit_bad if {
	not commit_actions_with_a_loop.allow with input as loop_commit_bad_commit_action
	not commit_actions_with_a_loop.allow with input as loop_commit_bad_change_action
	not commit_actions_with_a_loop.allow with input as loop_commit_bad_all
}
