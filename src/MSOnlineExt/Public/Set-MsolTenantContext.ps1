function Set-MsolTenantContext
{
<#
.Synopsis
    Sets the default ID for the TenantId parameter.
.DESCRIPTION
    Long description
.EXAMPLE
    Set-MsolTenantContext -TenantId 41a3b096-8205-4a50-8259-8603c7a91d5a
.INPUTS
    System.Guid

    The cmdlet takes the TenantId as a Guid.
.OUTPUTS
    None
.NOTES
    Once the default TenantId is set all auto-completers will be updated to reflect the change.
.COMPONENT
    MSOnlineExt
.FUNCTIONALITY
    Sets the default ID for the TenantId parameter.
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
        [Guid] $TenantId
    )

    Begin
    {
    }

    Process
    {
        try
        {
            $global:PSDefaultParameterValues['*-Msol*:TenantId'] = $TenantId
            $completers_path = Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'Completers'
            $completers = Get-ChildItem -Path $completers_path -Filter '*.Completer.ps1' -ErrorAction SilentlyContinue
            foreach($item in $completers)
            {
                $message = 'Re-importing Completer: {0}' -f $item.FullName
                Write-Verbose -Message $message
                & $item.FullName
            }
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }

    End
    {
    }
}