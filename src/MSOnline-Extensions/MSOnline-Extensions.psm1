$completers_path = Join-Path -Path $PSScriptRoot -ChildPath 'Completers'
$completers = Get-ChildItem -Path $completers_path -Filter '*.Completer.ps1'

foreach($item in $completers)
{
    $message = 'Importing Completer: {0}' -f $item.FullName
    Write-Verbose -Message $message
    & $item.FullName
}

# This code will run when the module is removed and
# will be sure that the TenantId default is removed
$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = { $PSDefaultParameterValues.Remove('*-Msol*:TenantId') }