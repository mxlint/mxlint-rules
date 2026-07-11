# METADATA
# scope: package
# title: Avoid many-to-many associations owned by Both
# description: Using owner "Both" does not change the ability to navigate an association (that is always possible from both ends), but it does introduce overhead. Many-to-many associations should be owned by the Default entity unless there is a strong business reason.
# authors:
# - Xiwen Cheng <x@cinaq.com>
# related_resources:
# - https://sdf-docs.clevr.com/?docs=acr-rules/performance/associationownerboth
# custom:
#  category: Performance
#  rulename: AssociationOwnerBoth
#  severity: LOW
#  rulenumber: "002_0010"
#  remediation: Change the association owner to Default unless both-side ownership is genuinely required.
#  input: .*/DomainModels\$DomainModel\.yaml
package app.mendix.domain_model.association_owner_both

import rego.v1

annotation := rego.metadata.chain()[1].annotations

default allow := false

allow if count(errors) == 0

errors contains error if {
	some association in input.Associations
	association.Owner == "Both"

	error := sprintf(
		"[%v, %v, %v] Association %v is owned by Both, which introduces unnecessary overhead",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
			association.Name,
		],
	)
}

errors contains error if {
	some association in input.CrossAssociations
	association.Owner == "Both"

	error := sprintf(
		"[%v, %v, %v] Association %v is owned by Both, which introduces unnecessary overhead",
		[
			annotation.custom.severity,
			annotation.custom.category,
			annotation.custom.rulenumber,
			association.Name,
		],
	)
}
