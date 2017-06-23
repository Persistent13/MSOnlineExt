function Remove-MsolTenantContext
{
    [CmdletBinding(SupportsShouldProcess=$true,
                   PositionalBinding=$false,
                   ConfirmImpact='Low')]
    Param()

    Begin
    {
        if($PSDefaultParameterValues['*-Msol*:TenantId'] -eq $null)
        {
            Write-Verbose -Message 'Default TenantId has not been set. Please run Set-MsolTenantContext.'
            $target = '00000000-0000-0000-0000-000000000000'
        }
        else
        {
            $target = $PSDefaultParameterValues['*-Msol*:TenantId']
        }
    }

    Process
    {
        if($PSCmdlet.ShouldProcess($target,'Remove default tenant ID.'))
        {
            try
            {
                $PSDefaultParameterValues.Remove('*-Msol*:TenantId')
            }
            catch
            {
                $PSCmdlet.ThrowTerminatingError($PSItem)
            }
        }
    }

    End
    {
    }
}