function Remove-MsolTenantContext
{
<#
.Synopsis
    Removes the default ID for the TenantId parameter.
.DESCRIPTION
    Removes the default ID for the TenantId parameter.

    Once the default ID for the TenantId parameter is removed the default behavior of the MSOnline cmdlets is restored.
.EXAMPLE
    Remove-MsolTenantContext

    The above command will remove the default TenantId parameter, if present.
.INPUTS
    None
.OUTPUTS
    None
.NOTES
    Once the default ID for the TenantId parameter is removed the default behavior of the MSOnline cmdlets is restored.
.COMPONENT
    MSOnlineExt
.FUNCTIONALITY
    Removes the default ID for the TenantId parameter.
#>
    [CmdletBinding(SupportsShouldProcess=$true,
                   PositionalBinding=$false,
                   ConfirmImpact='Low')]
    Param()

    Begin
    {
        $script:app.TrackEvent('Ran function: {0}' -f $MyInvocation.MyCommand.Name)
        if($script:module_config.ApplicationInsights.TelemetryPrompt){ Write-TelemetryPrompt }

        if($global:PSDefaultParameterValues['*-Msol*:TenantId'] -eq $null)
        {
            Write-Verbose -Message 'Default TenantId has not been set. Please run Set-MsolTenantContext.'
            $target = '00000000-0000-0000-0000-000000000000'
        }
        else
        {
            $target = $global:PSDefaultParameterValues['*-Msol*:TenantId']
        }
    }

    Process
    {
        try
        {
            if($PSCmdlet.ShouldProcess($target,'Remove default tenant ID.'))
            {
                $global:PSDefaultParameterValues.Remove('*-Msol*:TenantId')
            }
        }
        catch
        {
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