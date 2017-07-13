$ErrorActionPreference = 'Stop'
try
{
    $script:module_config_path = Microsoft.PowerShell.Management\Join-Path -Path $PSScriptRoot -ChildPath 'MSOnlineExt.config.json'
    $script:module_config = Microsoft.PowerShell.Management\Get-Content -Path $script:module_config_path -Raw | Microsoft.PowerShell.Utility\ConvertFrom-Json

    $app_settings = [Microsoft.ApplicationInsights.Extensibility.TelemetryConfiguration]::new()
    # If disabled no telemetry will be sent
    $app_settings.DisableTelemetry = $script:module_config.ApplicationInsights.TelemetryDisable

    # Load application insights
    $script:app = [Microsoft.ApplicationInsights.TelemetryClient]::new($app_settings)
    # Gather session data
    $script:app.InstrumentationKey = 'c7587407-2b8a-4ebe-8c9f-3586e05f302d'
    $script:app.TrackEvent('Execution Context: {0}' -f $ExecutionContext.Host.Name)
    $script:app.TrackEvent('PowerShell Version: {0}' -f $PSVersionTable.PSVersion.ToString())
    $script:app.TrackEvent('PowerShell Edition: {0}' -f $PSEdition)
    $script:app.TrackEvent('Is 64 Bit Operating System: {0}' -f [System.Environment]::Is64BitOperatingSystem)
    $script:app.TrackEvent('Is 64 Bit Process: {0}' -f [System.Environment]::Is64BitProcess)
    $script:app.Flush()
}
catch
{
    Microsoft.PowerShell.Utility\Write-Error -Message "Failed to set telemetry options: $PSItem"
}

# Get all module file paths.
$completers_path = Microsoft.PowerShell.Management\Join-Path -Path $PSScriptRoot -ChildPath 'Completers'
$public_path = Microsoft.PowerShell.Management\Join-Path -Path $PSScriptRoot -ChildPath 'Public'
$private_path = Microsoft.PowerShell.Management\Join-Path -Path $PSScriptRoot -ChildPath 'Private'

# Get all module files.
$public = @( Microsoft.PowerShell.Management\Get-ChildItem -Path $public_path -Filter '*.ps1' )
$private = @( Microsoft.PowerShell.Management\Get-ChildItem -Path $private_path -Filter '*.ps1' )
$completers = Microsoft.PowerShell.Management\Get-ChildItem -Path $completers_path -Filter '*.Completer.ps1'

# Load all completers.
foreach($item in $completers)
{
    $message = 'Importing Completer: {0}' -f $item.FullName
    Microsoft.PowerShell.Utility\Write-Verbose -Message $message
    & $item.FullName
}

# Load all functions.
foreach($cmdlet in @($public + $private))
{
    try
    {
        . $cmdlet.FullName
    }
    catch
    {
        Microsoft.PowerShell.Utility\Write-Error -Message "Failed to import cmdlet $($cmdlet.FullName): $PSItem"
    }
}

if($script:module_config.ApplicationInsights.TelemetryPrompt){ Write-TelemetryPrompt }

# Present public functions to user
Microsoft.PowerShell.Core\Export-ModuleMember -Function $public.BaseName

# This code will run when the module is removed and
# will be sure that the TenantId default is removed
$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = { $global:PSDefaultParameterValues.Remove('*-Msol*:TenantId') }
