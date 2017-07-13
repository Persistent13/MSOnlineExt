$param_name = 'SubscriptionId'
$cmdlets = Microsoft.PowerShell.Core\Get-Command -Module 'MSOnline' -ParameterName $param_name

$argument_completer = @{
    CommandName = $cmdlets.Name
    ParameterName = $param_name
    ScriptBlock = {
        param($command_name, $parameter_name, $word_to_complete, $command_ast, $fake_bound_parameter)

        $item_list = MSOnline\Get-MsolPartnerContract | Microsoft.PowerShell.Core\Where-Object { $PSItem.SkuPartNumber -match $word_to_complete } | Microsoft.PowerShell.Core\ForEach-Object {
            $completion_text = $PSItem.ObjectId
            $tool_tip = 'All available licenses for the selected tenant.'
            $list_item_text = $PSItem.
            $completion_result_type = [System.Management.Automation.CompletionResultType]::ParameterValue

            [System.Management.Automation.CompletionResult]::new($completion_text,$list_item_text,$completion_result_type,$tool_tip)
        }

        return $item_list
    }
}

Microsoft.PowerShell.Core\Register-ArgumentCompleter @argument_completer
