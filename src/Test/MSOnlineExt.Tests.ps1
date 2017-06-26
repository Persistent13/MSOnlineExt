$global:test_guid = New-Guid
$global:test_guid_empty = [guid]::Empty
$global:test_guid_static = '230a7523-6117-4f5f-9209-7fb5807416f1'

InModuleScope MSOnlineExt {
    Describe 'Get-MsolTenantContext' {
        Context 'Set-MsolTenantContext has been run' {

            Mock Set-MsolTenantContext { $global:PSDefaultParameterValues['*-Msol*:TenantId'] = $global:test_guid } -Verifiable
            Set-MsolTenantContext -TenantId $global:test_guid_static
            It 'Set-MsolTenantContext has been run' {
                Assert-VerifiableMocks
            }
            It 'Returns the correct Guid' {
                Get-MsolTenantContext | Should Be $global:test_guid
            }
        }
        Context 'Set-MsolTenantContext has NOT been run' {

            $global:PSDefaultParameterValues.Remove('*-Msol*:TenantId')

            It 'Returns the correct Guid' {
                Get-MsolTenantContext | Should Be $global:test_guid_empty
            }
        }
    }
    Describe 'Remove-MsolTenantContext' {
        Context 'Set-MsolTenantContext has been run' {

            Mock Set-MsolTenantContext { $global:PSDefaultParameterValues['*-Msol*:TenantId'] = $global:test_guid } -Verifiable
            Set-MsolTenantContext -TenantId $global:test_guid_static

            It 'Set-MsolTenantContext has been run' {
                Assert-VerifiableMocks
            }
            It 'Removes the default Guid' {
                Remove-MsolTenantContext
                $global:PSDefaultParameterValues['*-Msol*:TenantId'] | Should Be $null
            }
        }
        Context 'Set-MsolTenantContext has NOT been run' {

            $global:PSDefaultParameterValues.Remove('*-Msol*:TenantId')

            It 'No error is thrown' {
                { Remove-MsolTenantContext } | Should Not Throw
            }
        }
    }
    Describe 'Set-MsolTenantContext' {
        Context 'Set-MsolTenantContext has NOT been run' {
            It 'Sets the correct Guid' {
                Set-MsolTenantContext -TenantId $global:test_guid
                $global:PSDefaultParameterValues['*-Msol*:TenantId'] | Should Be $global:test_guid
            }
            It 'Throws an error with bad parameter' {
                { Set-MsolTenantContext -TenantId 'BAD IDEA' } | Should Throw
            }
        }
    }
}
