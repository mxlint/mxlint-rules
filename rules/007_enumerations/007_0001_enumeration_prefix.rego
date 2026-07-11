# METADATA
# scope: package
# title: Enumerations should have a recognizable prefix
# description: Prefixing enumerations with a short string such as ENU makes it much easier to find all enumerations, for example in microflow expressions.
# authors:
# - Xiwen Cheng <x@cinaq.com>
# related_resources:
# - https://sdf-docs.clevr.com/?docs=acr-rules/project-hygiene/enumprefix
# custom:
#  category: ProjectHygiene
#  rulename: EnumerationPrefix
#  severity: LOW
#  rulenumber: "007_0001"
#  remediation: Rename the enumeration so that it starts with the agreed prefix, for example ENU_Status.
#  input: .*\.Enumerations\$Enumeration\.yaml
package app.mendix.enumerations.enumeration_prefix

import rego.v1

annotation := rego.metadata.chain()[1].annotations

required_prefix := "ENU"

default allow := false

allow if count(errors) == 0

errors contains error if {
	input["$Type"] == "Enumerations$Enumeration"
	not startswith(input.Name, required_prefix)

	error := sprintf(
		"[%v, %v, %v] Enumeration %v does not start with the required prefix %v",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
			input.Name,
			required_prefix,
		],
	)
}
