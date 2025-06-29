# METADATA
# scope: package
# title: Mendix Admin userid not allowed to be MxAdmin
# description: Check the mendix admin userid and should not be default value (MxAdmin)
# authors:
# - Andre Luijkx
# custom:
#  category: Security
#  rulename: MxAdminNotUsed
#  severity: HIGH
#  rulenumber: 001_0005
#  remediation: Rename the mendix admin userid
#  input: .*Security\$ProjectSecurity\.yaml
package app.mendix.project_settings.mxadmin_userid
import rego.v1
annotation := rego.metadata.chain()[1].annotations

default allow := false
allow if count(errors) == 0

errors contains error if {
    input.AdminUserName == "MxAdmin"
    error := sprintf("[%v, %v, %v] %v",
        [
            annotation.custom.severity,
            annotation.custom.category,
            annotation.custom.rulenumber,
            annotation.title,
        ]
    )
}
