$completers = Get-ChildItem -Path "$PSScriptRoot\Completers\" -Filter '*.ps1' -ErrorAction SilentlyContinue

foreach($item in $completers)
{
    $message = 'Importing Completer: {0}' -f $import.FullName
    Write-Verbose -Message $message
    & $item.FullName
}