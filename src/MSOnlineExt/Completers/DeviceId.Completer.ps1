$param_name = 'DeviceId'
$cmdlets = Microsoft.PowerShell.Core\Get-Command -Module 'MSOnline' -ParameterName $param_name

$argument_completer = @{
    CommandName = $cmdlets.Name
    ParameterName = $param_name
    ScriptBlock = {
        param($command_name, $parameter_name, $word_to_complete, $command_ast, $fake_bound_parameter)

        $item_list = MSOnline\Get-MsolDevice -All | Microsoft.PowerShell.Core\Where-Object { $PSItem.DisplayName -match $word_to_complete } | Microsoft.PowerShell.Core\ForEach-Object {
            $completion_text = $PSItem.DeviceId
            $tool_tip = 'The device ID for all devices in the selected tenant.'
            $list_item_text = $PSItem.DisplayName
            $completion_result_type = [System.Management.Automation.CompletionResultType]::ParameterValue

            [System.Management.Automation.CompletionResult]::new($completion_text,$list_item_text,$completion_result_type,$tool_tip)
        }

        return $item_list
    }
}

Microsoft.PowerShell.Core\Register-ArgumentCompleter @argument_completer
