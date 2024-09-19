package app.mendix.microflows.commit_actions_with_a_loop
import rego.v1


# Test data
loop_commit_good = {
  "$Type": "Microflow$Microflow",
  "Name": "MicroflowForLoop",
  "MainFunction": [
    {
      "Attributes": {
        "$Type": "Microflows$LoopedActivity",
        "ObjectCollection": {
          "$Type": "Microflows$MicroflowObjectCollection",
          "Objects": [
            {
              "$Type": "Microflows$ActionActivity",
              "Action": {
                "$Type": "Microflows$ChangeAction",
                "Commit": "No"
              }
            }
          ]
        }
      }
    }
  ]
}

loop_commit_bad = {
  "$Type": "Microflow$Microflow",
  "Name": "MicroflowForLoop",
  "MainFunction": [
    {
      "Attributes": {
        "$Type": "Microflows$LoopedActivity",
        "ObjectCollection": {
          "$Type": "Microflows$MicroflowObjectCollection",
          "Objects": [
            {
              "$Type": "Microflows$ActionActivity",
              "Action": {
                "$Type": "Microflows$CommitAction"
              }
            },
            {
              "$Type": "Microflows$ActionActivity",
              "Action": {
                "$Type": "Microflows$ChangeAction",
                "Commit": "Yes"
              }
            }
          ]
        }
      }
    }
  ]
}


# Test cases
test_loop_commit_good if {
	allow with input as loop_commit_good
}

test_loop_commit_bad if {
	not allow with input as loop_commit_bad
}
