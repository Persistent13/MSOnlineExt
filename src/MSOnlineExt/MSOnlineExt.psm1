$ErrorActionPreference = 'Stop'
try
{
    $script:module_config_path = Join-Path -Path $PSScriptRoot -ChildPath 'MSOnlineExt.config.json'
    $script:module_config = Get-Content -Path $script:module_config_path -Raw | ConvertFrom-Json

    if($script:module_config.ApplicationInsights.TelemetryPrompt){ Write-TelemetryPrompt }

    $app_client_settings = [Microsoft.ApplicationInsights.Extensibility.TelemetryConfiguration]::new()
    # If disabled no telemetry will be sent
    $app_client_settings.DisableTelemetry = $script:module_config.ApplicationInsights.TelemetryDisable
    $app_client_settings.InstrumentationKey = ''

    # Load application insights
    $script:app = [Microsoft.ApplicationInsights.TelemetryClient]::new($app_client_settings)
    # Gather session data
    $script:app.TrackEvent('Execution Context: {0}' -f $ExecutionContext.Host.Name)
    $script:app.TrackEvent('PowerShell Version: {0}' -f $PSVersionTable.PSVersion.Major)
    $script:app.TrackEvent('PowerShell Edition: {0}' -f $PSEdition)
    $script:app.TrackEvent('Is 64 Bit Operating System: {0}' -f [System.Environment]::Is64BitOperatingSystem)
    $script:app.TrackEvent('Is 64 Bit Process: {0}' -f [System.Environment]::Is64BitProcess)
    $script:app.Flush()
}
catch
{
    Write-Error -Message "Failed to set telemetry options: $PSItem"
}

# Get all module file paths.
$completers_path = Join-Path -Path $PSScriptRoot -ChildPath 'Completers'
$public_path = Join-Path -Path $PSScriptRoot -ChildPath 'Public'
$private_path = Join-Path -Path $PSScriptRoot -ChildPath 'Private'

# Get all module files.
$public = @( Get-ChildItem -Path $public_path -Filter '*.ps1' )
$private = @( Get-ChildItem -Path $private_path -Filter '*.ps1' )
$completers = Get-ChildItem -Path $completers_path -Filter '*.Completer.ps1'

# Load all completers.
foreach($item in $completers)
{
    $message = 'Importing Completer: {0}' -f $item.FullName
    Write-Verbose -Message $message
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
        Write-Error -Message "Failed to import cmdlet $($cmdlet.FullName): $PSItem"
    }
}

# Present public functions to user
Export-ModuleMember -Function $public.BaseName

# This code will run when the module is removed and
# will be sure that the TenantId default is removed
$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = { $global:PSDefaultParameterValues.Remove('*-Msol*:TenantId') }
