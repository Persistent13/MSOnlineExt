$test_guid = New-Guid
$test_guid_empty = [guid]::Empty
$test_guid_static = '230a7523-6117-4f5f-9209-7fb5807416f1'

$module_path = Join-Path -Path ( Join-Path -Path $PSScriptRoot -ChildPath 'MSOnlineExt' ) -ChildPath 'MSOnlineExt.psd1'

Import-Module 'MSOnline'
Import-Module $module_path

InModuleScope MSOnlineExt {
    Describe 'Get-MsolTenantContext' {
        Context 'Set-MsolTenantContext has been run' {

            Mock Set-MsolTenantContext { $global:PSDefaultParameterValues['*-Msol*:TenantId'] = $test_guid }
            Set-MsolTenantContext -TenantId $test_guid_static

            Assert-MockCalled Set-MsolTenantContext

            It 'Returns the correct Guid' {
                Get-MsolTenantContext | Should Be $test_guid
            }
        }
        Context 'Set-MsolTenantContext has NOT been run' {
            It 'Returns the correct Guid' {
                Get-MsolTenantContext | Should Be $test_guid_empty
            }
        }
    }
    Describe 'Remove-MsolTenantContext' {
        Context 'Set-MsolTenantContext has been run' {

            Mock Set-MsolTenantContext { $global:PSDefaultParameterValues['*-Msol*:TenantId'] = $test_guid }
            Set-MsolTenantContext -TenantId $test_guid_static

            Assert-MockCalled Set-MsolTenantContext

            It 'Removes the default Guid' {
                Remove-MsolTenantContext
                $global:PSDefaultParameterValues['*-Msol*:TenantId'] | Should Be $null
            }
        }
        Context 'Set-MsolTenantContext has NOT been run' {
            It 'Throws an error' {
                { Remove-MsolTenantContext } | Should Throw
            }
        }
    }
    Describe 'Set-MsolTenantContext' {
        It 'Sets the correct Guid' {
            Set-MsolTenantContext -TenantId $test_guid
            $global:PSDefaultParameterValues['*-Msol*:TenantId'] | Should Be $test_guid
        }
        It 'Throws an error with bad parameter' {
            { Set-MsolTenantContext -TenantId 'BAD IDEA' } | Should Throw
        }
    }
}
