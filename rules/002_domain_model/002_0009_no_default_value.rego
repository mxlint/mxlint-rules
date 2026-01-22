# METADATA
# scope: package
# title: Do not use default values on attributes
# description: Avoid default values because it introduces hidden logic that is hard to detect via "find changes".
# authors:
# - Rick Schreuder <rick.schreuder@valcon.com>
# custom:
#  category: Maintainability
#  rulename: NoDefaultValue
#  severity: LOW
#  rulenumber: 002_0009
#  remediation: Remove the attribute default value and set it explicitly in logic where needed.
#  input: .*DomainModels\$DomainModel\.yaml

package app.mendix.domain_model.no_default_value

import rego.v1

# Load custom rule annotations (severity, category, rule number).
annotation := rego.metadata.chain()[1].annotations

# The file is valid only if no rule violations are found.
default allow := false
allow if count(errors) == 0

# A default value is considered "set" if it exists AND it is not the empty string.
default_value_is_set(default_value) if {
  default_value != null
  not is_empty_string(default_value)
}

# Checks whether a value is exactly an empty string.
is_empty_string(value) if {
  is_string(value)
  value == ""
}

# Emit an error for each attribute that defines a DefaultValue.
errors contains error_message if {
  some entity_index
  some attribute_index

  entity := input.Entities[entity_index]
  attribute := entity.Attributes[attribute_index]

  # In the DomainModel yaml, DefaultValue is nested under Value
  stored_value := object.get(attribute, "Value", {})
  default_value := object.get(stored_value, "DefaultValue", null)

  default_value_is_set(default_value)

  error_message := sprintf("[%v, %v, %v] %v.%v has a default value set",
    [
      annotation.custom.severity,
      annotation.custom.category,
      annotation.custom.rulenumber,
      entity.Name,
      attribute.Name
    ]
  )
}