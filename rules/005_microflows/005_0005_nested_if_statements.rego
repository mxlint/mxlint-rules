# METADATA
# scope: package
# title: Nested if-statements
# description: Microflow actions with nested if-statements hide complexity and are harder to maintain.
# authors:
# - Bart Zantingh <bart.zantingh@nl.abnamro.com>
# custom:
#  category: Complexity
#  rulename: NestedIfStatements
#  severity: MEDIUM
#  rulenumber: "005_0005"
#  remediation: Simplify the expression or use exclusive splits.
#  input: "**/*$Microflow.yaml"
package app.mendix.microflows.nested_if_statements

import rego.v1

annotation := rego.metadata.chain()[1].annotations

default allow := false

allow if count(errors) == 0

regex_to_match := `^[\S\s]*(then|else)[\S\s]*(if)[\S\s]*$`

errors contains error if {
	some ex_split in input.ObjectCollection.Objects
	ex_split["$Type"] == "Microflows$ExclusiveSplit"

	regex.match(regex_to_match, ex_split.SplitCondition.Expression)

	error := sprintf(
		"[%v, %v, %v] Exclusive split with caption '%v' has nested if-statements in its expression",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
			ex_split.Caption,
		],
	)
}
