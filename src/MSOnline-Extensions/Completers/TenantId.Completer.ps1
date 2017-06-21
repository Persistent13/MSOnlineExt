$argument_completer = @{
    CommandName = @('Add-MsolAdministrativeUnitMember',
                    'Add-MsolForeignGroupToRole',
                    'Add-MsolGroupMember',
                    'Add-MsolRoleMember',
                    'Add-MsolScopedRoleMember',
                    'Confirm-MsolDomain',
                    'Confirm-MsolEmailVerifiedDomain',
                    'Convert-MsolFederatedUser',
                    'Get-MsolAccountSku',
                    'Get-MsolAdministrativeUnit',
                    'Get-MsolAdministrativeUnitMember',
                    'Get-MsolCompanyAllowedDataLocation',
                    'Get-MsolCompanyInformation',
                    'Get-MsolContact',
                    'Get-MsolDirSyncConfiguration',
                    'Get-MsolDirSyncFeatures',
                    'Get-MsolDirSyncProvisioningError',
                    'Get-MsolDomain',
                    'Get-MsolDomainFederationSettings',
                    'Get-MsolDomainVerificationDns',
                    'Get-MsolGroup',
                    'Get-MsolGroupMember',
                    'Get-MsolHasObjectsWithDirSyncProvisioningErrors',
                    'Get-MsolPartnerContract',
                    'Get-MsolPartnerInformation',
                    'Get-MsolPasswordPolicy',
                    'Get-MsolRole',
                    'Get-MsolRoleMember',
                    'Get-MsolScopedRoleMember',
                    'Get-MsolServicePrincipal',
                    'Get-MsolServicePrincipalCredential',
                    'Get-MsolSubscription',
                    'Get-MsolUser',
                    'Get-MsolUserByStrongAuthentication',
                    'Get-MsolUserRole',
                    'New-MsolAdministrativeUnit',
                    'New-MsolDomain',
                    'New-MsolGroup',
                    'New-MsolServicePrincipal',
                    'New-MsolServicePrincipalCredential',
                    'New-MsolUser',
                    'New-MsolWellKnownGroup',
                    'Redo-MsolProvisionContact',
                    'Redo-MsolProvisionGroup',
                    'Redo-MsolProvisionUser',
                    'Remove-MsolAdministrativeUnit',
                    'Remove-MsolAdministrativeUnitMember',
                    'Remove-MsolApplicationPassword',
                    'Remove-MsolContact',
                    'Remove-MsolDomain',
                    'Remove-MsolForeignGroupFromRole',
                    'Remove-MsolGroup',
                    'Remove-MsolGroupMember',
                    'Remove-MsolRoleMember',
                    'Remove-MsolScopedRoleMember',
                    'Remove-MsolServicePrincipal',
                    'Remove-MsolServicePrincipalCredential',
                    'Remove-MsolUser',
                    'Reset-MsolStrongAuthenticationMethodByUpn',
                    'Restore-MsolUser',
                    'Set-MsolAdministrativeUnit',
                    'Set-MsolCompanyAllowedDataLocation',
                    'Set-MsolCompanyContactInformation',
                    'Set-MsolCompanyMultiNationalEnabled',
                    'Set-MsolCompanySecurityComplianceContactInformation',
                    'Set-MsolCompanySettings',
                    'Set-MsolDirSyncConfiguration',
                    'Set-MsolDirSyncEnabled',
                    'Set-MsolDirSyncFeature',
                    'Set-MsolDomain',
                    'Set-MsolDomainAuthentication',
                    'Set-MsolDomainFederationSettings',
                    'Set-MsolGroup',
                    'Set-MsolPartnerInformation',
                    'Set-MsolPasswordPolicy',
                    'Set-MsolServicePrincipal',
                    'Set-MsolUser',
                    'Set-MsolUserLicense',
                    'Set-MsolUserPassword',
                    'Set-MsolUserPrincipalName')
    ParameterName = 'TenantId'
    ScriptBlock = {
        param($command_name, $parameter_name, $word_to_complete, $command_ast, $fake_bound_parameter)

        $item_list = Get-MsolPartnerContract | Where-Object { $PSItem.Name -match $word_to_complete } | ForEach-Object {
            $completion_text = $PSItem.TenantId
            $tool_tip = 'The Tenant ID for Office 365 partners.'
            $list_item_text = $PSItem.Name
            $completion_result_type = [System.Management.Automation.CompletionResultType]::ParameterValue

            New-Object [System.Management.Automation.CompletionResult]($completion_text,$list_item_text,$completion_result_type,$tool_tip)
        }

        return $item_list
    }
}

Register-ArgumentCompleter @argument_completer