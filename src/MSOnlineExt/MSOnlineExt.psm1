# Get all module file paths.
$completers_path = Join-Path -Path $PSScriptRoot -ChildPath 'Completers'
$public_path = Join-Path -Path $PSScriptRoot -ChildPath 'Public'

# Get all module files.
$public = @( Get-ChildItem -Path $public_path -Filter '*.ps1' )
$completers = Get-ChildItem -Path $completers_path -Filter '*.Completer.ps1'

# Load all completers.
foreach($item in $completers)
{
    $message = 'Importing Completer: {0}' -f $item.FullName
    Write-Verbose -Message $message
    & $item.FullName
}

# Load all functions.
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
$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {
    try { $global:PSDefaultParameterValues.Remove('*-Msol*:TenantId') }
    catch {  }
    # We don't handle the error because if it errored then the key
    # was already removed by the user prior to unloading the module.
    # We only do this to stop errors from polluting the console.
}