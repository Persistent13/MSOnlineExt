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
        [Guid]$TenantId
    )

    Begin
    {
    }

    Process
    {
        try
        {
            $PSDefaultParameterValues.Add('*-Msol*:TenantId',$TenantId)

            $completers = Get-ChildItem -Path "$PSScriptRoot\..\Completers\" -Filter '*.ps1' -ErrorAction SilentlyContinue
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