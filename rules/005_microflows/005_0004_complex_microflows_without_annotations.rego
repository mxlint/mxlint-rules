# METADATA
# scope: package
# title: Complex microflows without annotations
# description: Microflows with more than 10 actions and/or 2 decisions can be hard to understand.
# authors:
# - Bart Zantingh <bart.zantingh@nl.abnamro.com>
# custom:
#  category: Maintainability
#  rulename: ComplexMicroflowsWithoutAnnotations
#  severity: MEDIUM
#  rulenumber: 005_0004
#  remediation: Add one or more annotations to explain the microflow.
#  input: .*\$Microflow\.yaml

package app.mendix.microflows.complex_microflows_without_annotations

import rego.v1

annotation := rego.metadata.chain()[1].annotations

default allow := false

allow if count(errors) == 0

errors contains error if {
	is_complex

	# if MF Is complex, collect all objects of type Microflows$Annotations from input file
	annotation_collection := [annotation |
		some annotation in input.ObjectCollection.Objects
		annotation["$Type"] == "Microflows$Annotation"
	]

	count(annotation_collection) == 0

	error := sprintf(
		"[%v, %v, %v] Microflow %v has more than 10 activities and/or more than 2 exclusive splits, but no annotations",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
			input.Name,
		],
	)
}

# A microflow is considered complex if one or more of these conditions are met:
# - it has more than 10 actions
# - it has more than 2 exclusive splits
# based on Mendix Best Practices for Development paragraph 4.3.2
# see https://docs.mendix.com/refguide/dev-best-practices/#documentation-and-annotations

is_complex if {
	ex_splits_collection := [ex_split |
		some ex_split in input.ObjectCollection.Objects
		ex_split["$Type"] == "Microflows$ExclusiveSplit"
	]

	count(ex_splits_collection) > 2
}

is_complex if {
	activity_collection := [activity |
		some activity in input.ObjectCollection.Objects
		activity["$Type"] == "Microflows$ActionActivity"
	]

	count(activity_collection) > 10
}
