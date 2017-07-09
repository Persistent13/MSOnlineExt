function Get-MSOnlineExtTelemetryOption
{
<#
.Synopsis
    Gets the telemetry options for the module.
.DESCRIPTION
    Gets the telemetry options for the module.

    The default state is to disable telemetry. Please concider enabling telemetry to assist with improving the MSOnlineExt module.
.EXAMPLE
    Get-MsolTenantContext

    This command will enable telemetry and send us on the road of improving the MSOnlineExt module.
    Thank you very much! The data will help us track errors and usage.
.INPUTS
    None
.OUTPUTS
    MSOnlineExt.TelemetryClientSetting

    This cmdlet will return an object that details the current state of telemtry gathering.
.NOTES
    Once the participation setting is set the telemetry warning will no longer be run.
.COMPONENT
    MSOnlineExt
.FUNCTIONALITY
    Gets the telemetry options for the module.
#>
    [CmdletBinding(SupportsShouldProcess=$false,
                   PositionalBinding=$false,
                   ConfirmImpact='Low')]
    Param ()

    Begin
    {
        $ErrorActionPreference = 'Stop'
        $script:app.TrackEvent('Ran function: {0}' -f $MyInvocation.MyCommand.Name)
    }

    Process
    {
        try
        {
            [PSCustomObject]@{
                PSTypeName = 'MSOnlineExt.TelemetryClientSetting'
                TelemetryDisabled = -not $script:app.IsEnabled()
                TelemetryDisabledInConfig = $script:module_config.ApplicationInsights.TelemetryDisable
            }
        }
        catch
        {
            $script:app.TrackException($PSItem)
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
        finally
        {
            $script:app.Flush()
        }
    }

    End
    {
    }
}