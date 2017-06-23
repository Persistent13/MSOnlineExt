$param_name = 'DomainName'
$cmdlets = Get-Command -Module 'MSOnline' -ParameterName $param_name

$argument_completer = @{
    CommandName = $cmdlets.Name
    ParameterName = $param_name
    ScriptBlock = {
        param($command_name, $parameter_name, $word_to_complete, $command_ast, $fake_bound_parameter)

        $item_list = Get-MsolDomain | Where-Object { $PSItem.Name -match $word_to_complete } | ForEach-Object {
            $completion_text = $PSItem.Name
            $tool_tip = 'Domains available to the selected tenant.'
            $list_item_text = $PSItem.Name
            $completion_result_type = [System.Management.Automation.CompletionResultType]::ParameterValue

            [System.Management.Automation.CompletionResult]::new($completion_text,$list_item_text,$completion_result_type,$tool_tip)
        }

        return $item_list
    }
}

Register-ArgumentCompleter @argument_completer