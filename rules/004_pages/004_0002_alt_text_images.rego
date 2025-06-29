# METADATA
# scope: package
# title: Images must have alt text
# description: All images must have alt text so that screen readers can describe them
# authors:
# - Xiwen Cheng <x@cinaq.com>
# custom:
#  category: Accessibility
#  rulename: ImagesWithAltText
#  severity: MEDIUM
#  rulenumber: "004_0002"
#  remediation: Set an alt text for the image
#  input: .*\.(Forms\$Page|Forms\$Snippet)\.yaml

package app.mendix.pages.images_with_alt_text
import rego.v1
annotation := rego.metadata.chain()[1].annotations

default allow := false
allow if count(errors) == 0

errors contains error if {
    # Find all CustomWidgets$WidgetObject with PrimitiveValue "fullImage"
    
    walk(input, [_, widget])
    widget["$Type"] == "CustomWidgets$CustomWidget"
    
    widget.Object["$Type"] == "CustomWidgets$WidgetObject"
    widgetName := widget.Name
    prop := widget.Object.Properties[_]
    prop.Value.PrimitiveValue == "fullImage"
    
    # Check that at least one Texts$Translation exists and has Text attribute set
    count([x |
        text_translation := widget.Object.Properties[_].Value.TextTemplate.Template.Items[_]
        text_translation["$Type"] == "Texts$Translation"
        text_translation.Text
        x := true
    ]) == 0
    
    error := sprintf("[%v, %v, %v] Image with name %v must have Text attribute set in all Translations",
        [
            annotation.custom.severity,
            annotation.custom.category,
            annotation.custom.rulenumber,
            widgetName,
        ]
    )
}