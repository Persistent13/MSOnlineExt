function Set-MSOnlineExtTelemetryOption
{
<#
.Synopsis
    Sets the telemetry options for the module.
.DESCRIPTION
    Sets the telemetry options for the module.

    The default state is to disable telemetry. Please concider enabling telemetry to assist with improving the MSOnlineExt module.
.EXAMPLE
    Set-MsolTenantContext -Participate $true

    This command will enable telemetry and send us on the road of improving the MSOnlineExt module.
    Thank you very much! The data will help us track errors and usage.
.EXAMPLE
    Set-MsolTenantContext -Participate $false

    This command will disable telemetry and no data will be sent.
    Please reconsider! The data will help us track errors and usage.
.INPUTS
    System.Boolean

    The cmdlet takes the Participate parameter as a Boolean.
.OUTPUTS
    None
.NOTES
    Once the participation setting is set the telemetry warning will no longer be run.
.COMPONENT
    MSOnlineExt
.FUNCTIONALITY
    Sets the telemetry options for the module.
#>
    [CmdletBinding(SupportsShouldProcess=$false,
                   PositionalBinding=$false,
                   ConfirmImpact='Low')]
    Param
    (
        [Parameter(Mandatory,
                   ValueFromPipeline=$false,
                   ValueFromPipelineByPropertyName=$false,
                   ValueFromRemainingArguments=$false,
                   Position=0)]
        [ValidateSet('Yes','No')]
        [String] $Participate
    )

    Begin
    {
        $ErrorActionPreference = 'Stop'
        $script:app.TrackEvent('Ran function: {0}' -f $MyInvocation.MyCommand.Name)
    }

    Process
    {
        try
        {
            # -Participate 'Yes' will enable telemetry
            if($Participate -eq 'Yes'){ $script:module_config.ApplicationInsights.TelemetryDisable = $false }
            # -Participate 'No' will disable telemetry
            if($Participate -eq 'No'){ $script:module_config.ApplicationInsights.TelemetryDisable = $true }
            $script:module_config.ApplicationInsights.TelemetryPrompt = $false
            $script:module_config | ConvertTo-Json -Compress | Set-Content -Path $script:module_config_path
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