function Get-MsolTenantContext
{
    [CmdletBinding(SupportsShouldProcess=$false,
                   PositionalBinding=$false,
                   ConfirmImpact='Low')]
    [OutputType([Guid])]
    Param()

    Begin
    {
    }

    Process
    {
        if($PSDefaultParameterValues['*-Msol*:TenantId'] -eq $null)
        {
            Write-Verbose -Message 'Default TenantId has not been set. Please run Set-MsolTenantContext.'
            [guid]$target = '00000000-0000-0000-0000-000000000000'
            return $target
        }
        else
        {
            return $PSDefaultParameterValues['*-Msol*:TenantId']
        }
    }

    End
    {
    }
}