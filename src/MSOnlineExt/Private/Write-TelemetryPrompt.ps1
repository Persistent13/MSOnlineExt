function Write-TelemetryPrompt
{
    $telemetry_message = @'
Please consider enabling telemetry to help us improve MSOnlineExt!

Join with the following command:

Set-MSOnlineExtTelemetryOption -Participate $true

To disable this warning and set your preference, use the following command and then reload the module:
Set-MSOnlineExtTelemetryOption -Participate $true or $false
'@

    Write-Warning -Message $telemetry_message
}