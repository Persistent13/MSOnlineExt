$completers_path = Join-Path -Path $PSScriptRoot -ChildPath 'Completers'
$public_path = Join-Path -Path $PSScriptRoot -ChildPath 'Public'
$public = @( Get-ChildItem -Path $public_path -Filter '*.ps1' )
$completers = Get-ChildItem -Path $completers_path -Filter '*.Completer.ps1'

foreach($item in $completers)
{
    $message = 'Importing Completer: {0}' -f $item.FullName
    Write-Verbose -Message $message
    & $item.FullName
}

foreach($cmdlet in $public)
{
    try
    {
        . $cmdlet.FullName
    }
    catch
    {
        Write-Error -Message "Failed to import cmdlet $($cmdlet.FullName): $PSItem"
    }
}

Export-ModuleMember -Function $public.BaseName

# This code will run when the module is removed and
# will be sure that the TenantId default is removed
$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = { $global:PSDefaultParameterValues.Remove('*-Msol*:TenantId') }