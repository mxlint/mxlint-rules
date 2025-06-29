# METADATA
# scope: package
# title: No more than 25 elements in a microflow
# description: The bigger a microflow, the harder it will be to maintain.
# authors:
# - Bart Zantingh <bart.zantingh@nl.abnamro.com>
# custom:
#  category: Maintainability
#  rulename: NumberOfElementsInMicroflow
#  severity: MEDIUM
#  rulenumber: 005_0003
#  remediation: Split microflow into logical, functional elements.
#  input: .*\$Microflow\.yaml
package app.mendix.microflows.number_of_elements_in_microflow

import rego.v1

annotation := rego.metadata.chain()[1].annotations

default allow := false

allow if count(errors) == 0

errors contains error if {
	name := input.Name

	count_elements := count(input.ObjectCollection.Objects) - 2
	count_elements > 25

	error := sprintf(
		"[%v, %v, %v] Microflow %v has %v actions which is more than 25",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
			name,
			count_elements,
		],
	)
}
