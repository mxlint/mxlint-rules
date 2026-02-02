# METADATA
# scope: package
# title: Access rules using XPath should only contain attributes and associations with Read access
# description: If an XPath uses attributes or associations with read and write access, it may cause a security breach
# authors:
# - Bart Zantingh <bart.zantingh@nl.abnamro.com>
# custom:
#  category: Security
#  rulename: AccessRuleXpathConstraintsWithReadWrite
#  severity: HIGH
#  rulenumber: "002_0010"
#  remediation: Ensure that all attributes and associations used in XPath constraints have read-only access
#  input: "*/DomainModels$DomainModel.yaml"
package app.mendix.domain_model.access_rules_with_read_write_in_xpath

import rego.v1

annotation := rego.metadata.chain()[1].annotations

default allow := false

allow if count(errors) == 0

# check XPaths for attributes with ReadWrite access
errors contains error if {
	some entity in input.Entities
	entity_name := entity.Name

	attributes := [attribute |
		some attribute in entity.Attributes
		attribute["$Type"] == "DomainModels$Attribute"
	]

	some attribute in attributes
	has_read_write_access_to_attribute(entity, attribute.Name)
	used_in_xpath(entity, attribute.Name)

	error := sprintf(
		"[%v, %v, %v] Entity %v has an XPath constraint that uses one or more attributes with read/write access",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
			entity_name,
		],
	)
}

# check XPaths for associations with ReadWrite access
errors contains error if {
	some association in input.Associations

	some entity in input.Entities
	has_read_write_access_to_association(entity, association.Name)
	used_in_xpath(entity, association.Name)

	entity_name := entity.Name

	error := sprintf(
		"[%v, %v, %v] Entity %v has an XPath constraint that uses one or more assocations with read/write access",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
			entity_name,
		],
	)
}

has_read_write_access_to_attribute(entity, attribute_name) if {
	some access_rule in entity.AccessRules

	some member_access in access_rule.MemberAccesses
	member_access.AccessRights == "ReadWrite"
	contains(member_access.Attribute, attribute_name)
}

has_read_write_access_to_association(entity, association_name) if {
	some access_rule in entity.AccessRules

	some member_access in access_rule.MemberAccesses
	member_access.AccessRights == "ReadWrite"
	contains(member_access.Association, association_name)
}

# check if there are XPath constraints that contain the name of the attribute or association
used_in_xpath(entity, search_term) if {
	some access_rule in entity.AccessRules
	contains(access_rule.XPathConstraint, search_term)
}
