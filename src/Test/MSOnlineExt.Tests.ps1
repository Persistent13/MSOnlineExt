InModuleScope MSOnlineExt {
    $script:test_guid = New-Guid
    $script:test_guid_empty = [guid]::Empty
    $script:test_guid_static = '230a7523-6117-4f5f-9209-7fb5807416f1'
    $script:app.InstrumentationKey = '' # Short circuit telemetry for tests to reduce bogus data sent.
    Mock Write-TelemetryPrompt { <# This should stay empty to stop warnings from running in this context. #> }

    Describe 'Telemetry settings' {
        Context 'Test requirements' {
            It '$script:app should be present' {
                $script:app | Should Not BeNullOrEmpty
            }
            It 'The instrumentation key set to an empty string for tests' {
                $script:app.InstrumentationKey | Should BeExactly ''
            }
        }
    }
    Describe 'Get-MsolTenantContext' {
        Context 'Set-MsolTenantContext has been run' {

            Mock Set-MsolTenantContext { $global:PSDefaultParameterValues['*-Msol*:TenantId'] = $script:test_guid } -Verifiable
            Set-MsolTenantContext -TenantId $script:test_guid_static
            It 'Set-MsolTenantContext has been run' {
                Assert-VerifiableMocks
            }
            It 'Returns the correct Guid' {
                Get-MsolTenantContext | Should Be $script:test_guid
            }
        }
        Context 'Set-MsolTenantContext has NOT been run' {

            $global:PSDefaultParameterValues.Remove('*-Msol*:TenantId')

            It 'Returns the correct Guid' {
                Get-MsolTenantContext | Should Be $script:test_guid_empty
            }
        }
    }
    Describe 'Remove-MsolTenantContext' {
        Context 'Set-MsolTenantContext has been run' {

            Mock Set-MsolTenantContext { $global:PSDefaultParameterValues['*-Msol*:TenantId'] = $script:test_guid } -Verifiable
            Set-MsolTenantContext -TenantId $script:test_guid_static

            It 'Set-MsolTenantContext has been run' {
                Assert-VerifiableMocks
            }
            It 'Removes the default Guid' {
                Remove-MsolTenantContext
                $global:PSDefaultParameterValues['*-Msol*:TenantId'] | Should BeNullOrEmpty
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
                Set-MsolTenantContext -TenantId $script:test_guid
                $global:PSDefaultParameterValues['*-Msol*:TenantId'] | Should Be $script:test_guid
            }
            It 'Throws an error with bad parameter' {
                { Set-MsolTenantContext -TenantId 'BAD IDEA' } | Should Throw
            }
        }
    }
    Describe 'Get-MSOnlineExtTelemetryOption' {
        Context 'Set-MSOnlineExtTelemetryOption has NOT been run' {
            It 'The correct type is returned' {
                (Get-MSOnlineExtTelemetryOption | Get-Member).TypeName[0] | Should BeExactly 'MSOnlineExt.TelemetryClientSetting'
            }
            It 'The expected default telemetry settings are returned' {
                (Get-MSOnlineExtTelemetryOption).TelemetryDisabled | Should Be $true
            }
            It 'The expected default telemetry settings are returned from config file' {
                (Get-MSOnlineExtTelemetryOption).TelemetryDisabledInConfig | Should Be $true
            }
        }
    }
    Describe 'Set-MSOnlineExtTelemetryOption' {
        Context 'Set-MSOnlineExtTelemetryOption has been run' {
            Mock Set-Content { $PSItem | Out-File -FilePath 'TestDrive:\MSOnlineExt.config.json' } -Verifiable
            It 'Returns the expected telemetry settings after disabling them' {
                Set-MSOnlineExtTelemetryOption -Participate 'No'
                Assert-VerifiableMocks
                $telemetry_disable = Get-MSOnlineExtTelemetryOption
                $telemetry_disable.TelemetryDisabled | Should Be $true
                $telemetry_disable.TelemetryDisabledInConfig | Should Be $true
            }
            It 'Returns the expected telemetry settings after enabling them' {
                Set-MSOnlineExtTelemetryOption -Participate 'Yes'
                Assert-VerifiableMocks
                $telemetry_enable = Get-MSOnlineExtTelemetryOption
                $telemetry_enable.TelemetryDisabled | Should Be $true
                $telemetry_enable.TelemetryDisabledInConfig | Should Be $false
            }
            It 'Throws an error with bad parameter' {
                { Set-MSOnlineExtTelemetryOption -Participate 'BAD IDEA' } | Should Throw
            }
        }
    }
    Describe '$global:PSDefaultParameterValues[''*-Msol*:TenantId''] is removed after module unload' {
        Context 'Remove-Module' {
            It 'The default parameter value is removed on module unload' {
                Set-MsolTenantContext -TenantId $script:test_guid
                Remove-Module 'MSOnlineExt'
                $global:PSDefaultParameterValues['*-Msol*:TenantId'] | Should BeNullOrEmpty
            }
        }
    }
}
Describe 'Module has been unloaded for post reload tests' {
    It 'Module is not loaded' {
        Get-Module -Name 'MSOnlineExt' | Should BeNullOrEmpty
    }
}
<#
    TODO: Find out why Get-Content mock is failing to run.
    Due to some issues I do not have a handle on yet the mock is not working.
    Manual testing is required to validate that telemetry settings are set correctly on module load.
#>

# Describe 'Get-MSOnlineExtTelemetryOption' {
#     #region Disable telmetry prompt on module import during tests
#     Mock Get-Content { return '{"ApplicationInsights":{"TelemetryDisable":false,"TelemetryPrompt":false}}' } -Verifiable
#     $global:WarningPreference = 'SilentlyContinue'
#     Import-Module ( Join-Path -Path ( Join-Path -Path ( Split-Path -Path $PSScriptRoot ) -ChildPath 'MSOnlineExt' ) -ChildPath 'MSOnlineExt.psm1' )
#     $global:WarningPreference = 'Continue'
#     Assert-VerifiableMocks
#     #endregion
#     Context 'Post module reload' {
#         It 'Telemetry is runnning' {
#             $telemetry = Get-MSOnlineExtTelemetryOption
#             $telemetry.TelemetryDisabled | Should Be $false
#             $telemetry.TelemetryDisabledInConfig | Should Be $false
#         }
#     }
# }
