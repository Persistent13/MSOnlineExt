$completers = Get-ChildItem -Path "$PSScriptRoot\Completers\" -Filter '*.ps1' -ErrorAction SilentlyContinue

foreach($item in $completers)
{
    $message = 'Importing Completer: {0}' -f $import.FullName
    Write-Verbose -Message $message
    & $item.FullName
}

# This code will run when the module is removed and
# will be sure that the TenantId default is removed
$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = { $PSDefaultParameterValues.Remove('*-Msol*:TenantId') }