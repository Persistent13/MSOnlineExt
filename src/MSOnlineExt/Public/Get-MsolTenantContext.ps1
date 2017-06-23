function Get-MsolTenantContext
{
<#
.Synopsis
    Gets the default ID for the TenantId parameter.
.DESCRIPTION
    Gets the default ID for the TenantId parameter.

    If the default TenantId has been set with Set-MsolTenantContext the current Guid will be returned.

    When the default TenantId has not yet been set an empty Guid of 00000000-0000-0000-0000-000000000000 will be returned.
.EXAMPLE
    Get-MsolTenantContext

    Guid
    ----
    41a3b096-8205-4a50-8259-8603c7a91d5a

    The above command will return the default TenantId when it is set.
.EXAMPLE
    PS C:\>Get-MsolTenantContext

    Guid
    ----
    00000000-0000-0000-0000-000000000000

    When the default TenantId has not yet been set an empty Guid will be returned.
.INPUTS
    None
.OUTPUTS
    System.Guid

        A Guid will be returned.
.NOTES
    When the default TenantId has not yet been set an empty Guid of 00000000-0000-0000-0000-000000000000 will be returned.
.COMPONENT
    MSOnlineExt
.FUNCTIONALITY
    Gets the default ID for the TenantID parameter.
#>
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
        if($global:PSDefaultParameterValues['*-Msol*:TenantId'] -eq $null)
        {
            Write-Verbose -Message 'Default TenantId has not been set. Please run Set-MsolTenantContext.'
            [guid]$target = '00000000-0000-0000-0000-000000000000'
            return $target
        }
        else
        {
            return $global:PSDefaultParameterValues['*-Msol*:TenantId']
        }
    }

    End
    {
    }
}