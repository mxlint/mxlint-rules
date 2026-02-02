# METADATA
# scope: package
# title: Unlimited length string attributes should not be editable by anonymous users
# description: A malicious agent could set a very long value for the attribute causing the database to run out of space
# authors:
# - Bart Zantingh <bart.zantingh@nl.abnamro.com>
# custom:
#  category: Security
#  rulename: UnlimitedLengthAttributesEditableByAnonymous
#  severity: CRITICAL
#  rulenumber: "002_0011"
#  remediation: Ensure that anonymous users have, at most, only read access to attributes with unlimited length
#  input: "*/DomainModels$DomainModel.yaml"
package app.mendix.domain_model.unlimited_length_attributes_editable_by_anonymous

import rego.v1

annotation := rego.metadata.chain()[1].annotations

default allow := false

allow if count(errors) == 0

errors contains error if {
	some entity in input.Entities

	anon_has_access(entity)

	attributes := [attribute |
		some attribute in entity.Attributes
		attribute["$Type"] == "DomainModels$Attribute"
		attribute.NewType["$Type"] == "DomainModels$StringAttributeType"
		attribute.NewType.Length == 0
	]

	some access_rule in entity.AccessRules
	some member_access in access_rule.MemberAccesses
	member_access.AccessRights == "ReadWrite"

	some attribute in attributes
	contains(member_access.Attribute, attribute.Name)

	error := sprintf(
		"[%v, %v, %v] String attribute %v in entity %v has unlimited length and seems to be editable by anonymous users",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
			attribute.Name,
			entity.Name,
		],
	)
}

anon_has_access(entity) if {
	some access_rule in entity.AccessRules
	some module_role in access_rule.AllowedModuleRoles
	contains(lower(module_role), "anon")
}
