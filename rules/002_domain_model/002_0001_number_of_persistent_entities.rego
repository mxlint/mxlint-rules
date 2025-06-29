# METADATA
# scope: package
# title: No more than 15 persistent entities within one domain model
# description: The bigger the domain models, the harder they will be to maintain. It adds complexity to your security model as well. The smaller the modules, the easier to reuse.
# authors:
# - Xiwen Cheng <x@cinaq.com>
# - Andre Luijkx
# custom:
#  category: Maintainability
#  rulename: NumberOfPersistantEntities
#  severity: MEDIUM
#  rulenumber: 002_0001
#  remediation: Split domain model into multiple modules.
#  input: .*/DomainModels\$DomainModel\.yaml
package app.mendix.domain_model.number_of_persistent_entities
import rego.v1
annotation := rego.metadata.chain()[1].annotations

default allow := false
allow if count(errors) == 0

max_entities := 15

errors contains error if {
    not input.Entities == null

    count_all := count(input.Entities)

    some i
    non_persistent_entities := [item | input.Entities[i].MaybeGeneralization.Persistable == false ; item := input.Entities[i]]
    count_non_persistent := count(non_persistent_entities)

    count_entities :=  count_all - count_non_persistent
    count_entities > max_entities
    error := sprintf("[%v, %v, %v] There are %v persistent entities which is more than %v",
        [
            annotation.custom.severity,
            annotation.custom.category,
            annotation.custom.rulenumber,
            count_entities,
            max_entities
        ]
    )
}
