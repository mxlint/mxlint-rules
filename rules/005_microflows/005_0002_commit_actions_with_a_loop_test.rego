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
        "Documentation": "",
        "ErrorHandlingType": "Rollback",
        "LoopSource": {
          "$Type": "Microflows$IterableList",
          "ListVariableName": "BikeList",
          "VariableName": "IteratorBike"
        },
        "ObjectCollection": {
          "$Type": "Microflows$MicroflowObjectCollection",
          "Objects": [
            {
              "$ID": "REoQzbooxUqlJfxtM61uuw==",
              "$Type": "Microflows$ActionActivity",
              "Action": {
                "$ID": "ePBJZv2ockmxBjt1gRJInw==",
                "$Type": "Microflows$ChangeAction",
                "ChangeVariableName": "IteratorBike",
                "Commit": "No",
                "ErrorHandlingType": "Rollback",
                "Items": [
                  {
                    "$ID": "vlZ2qLGLHkaufP+Kexafqg==",
                    "$Type": "Microflows$ChangeActionItem",
                    "Association": "",
                    "Attribute": "MyFirstModule.Bike.Name",
                    "Type": "Set",
                    "Value": "'abc'"
                  }
                ],
                "RefreshInClient": false
              },
              "AutoGenerateCaption": true,
              "BackgroundColor": "Default",
              "Caption": "Activity",
              "Disabled": false,
              "Documentation": "",
              "RelativeMiddlePoint": "184;120",
              "Size": "120;60"
            }
          ]
        }
      },
      "ID": "Rdteip+prkClEKtbbvRbHw=="
    }
  ]
}

loop_commit_bad = {
  "$Type": "Microflow$Microflow",
  "Name": "MicroflowForLoop",
  "MainFunction":[
    {
      "Attributes": {
        "$Type": "Microflows$LoopedActivity",
        "Documentation": "",
        "ErrorHandlingType": "Rollback",
        "LoopSource": {
          "$Type": "Microflows$IterableList",
          "ListVariableName": "BikeList",
          "VariableName": "IteratorBike"
        },
        "ObjectCollection": {
          "$Type": "Microflows$MicroflowObjectCollection",
          "Objects": [
            {
              "$ID": "JON699i5X06+mJmpljIlIQ==",
              "$Type": "Microflows$ActionActivity",
              "Action": {
                "$ID": "lBbh4nwji0+ufvpEbuKqgA==",
                "$Type": "Microflows$CommitAction",
                "CommitVariableName": "IteratorBike",
                "ErrorHandlingType": "Rollback",
                "RefreshInClient": false,
                "WithEvents": true
              },
              "AutoGenerateCaption": true,
              "BackgroundColor": "Default",
              "Caption": "Activity",
              "Disabled": false,
              "Documentation": "",
              "RelativeMiddlePoint": "186;100",
              "Size": "120;60",
              "Description": "Commits changes to the current bike in the iteration"
            }
          ]
        }
      },
      "ID": "Rdteip+prkClEKtbbvRbHw=="
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
