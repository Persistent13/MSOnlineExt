function Set-MsolTenantContext
{
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