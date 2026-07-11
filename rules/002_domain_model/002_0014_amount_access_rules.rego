# METADATA
# scope: package
# title: Limit the number of access rules per entity
# description: An entity with a large number of access rules is hard to reason about and increases the risk of misconfigured security. Keep the number of access rules per entity manageable.
# authors:
# - Xiwen Cheng <x@cinaq.com>
# related_resources:
# - https://sdf-docs.clevr.com/?docs=acr-rules/maintainability/amountaccessrules
# custom:
#  category: Maintainability
#  rulename: AmountAccessRules
#  severity: LOW
#  rulenumber: "002_0014"
#  remediation: Consolidate access rules or split the entity so that each entity has a manageable number of access rules.
#  input: .*/DomainModels\$DomainModel\.yaml
package app.mendix.domain_model.amount_access_rules

import rego.v1

annotation := rego.metadata.chain()[1].annotations

max_access_rules := 10

default allow := false

allow if count(errors) == 0

errors contains error if {
	some entity in input.Entities
	rule_count := count(entity.AccessRules)
	rule_count > max_access_rules

	error := sprintf(
		"[%v, %v, %v] Entity %v has %v access rules, which exceeds the maximum of %v",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
			entity.Name,
			rule_count,
			max_access_rules,
		],
	)
}
