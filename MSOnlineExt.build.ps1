task Deploy UpdateManifest, UnloadModule, Test, UnloadModule, LoadModule, {
    $deploy_root = Join-Path -Path ( Join-Path -Path $PSScriptRoot -ChildPath 'src' ) -ChildPath 'Deploy'
    Invoke-PSDeploy -Path $deploy_root
}
task Test {
    $test_path = Join-Path -Path ( Join-Path -Path $PSScriptRoot -ChildPath 'src' ) -ChildPath 'Test'
    if ($env:APPVEYOR)
    {
        $test_file = 'TestResults_{0}_{1}.xml' -f $PSVersionTable.PSVersion.ToString(), (Get-Date -UFormat '%Y%m%d-%H%M%S')
        $out_file = Join-Path -Path $test_path -ChildPath $test_file
        Invoke-Pester -Path $test_path -OutputFormat 'NUnitXml' -OutputFile $out_file
        $upload_params = @{
            Method = 'Post'
            UseBasicParsing = $true
            ContentType = 'multipart/form-data'
            Uri = 'https://ci.appveyor.com/api/testresults/nunit/{0}' -f $env:APPVEYOR_JOB_ID
            InFile = $out_file
        }
        Invoke-WebRequest @upload_params
    }
    else
    {
        # Any tests not run from Appveyor
        Invoke-Pester -Path $test_path
    }
}
task LoadModule {
    if(-not (Get-Module -Name 'MSOnlineExt')){ Import-Module $manifest_path }
}
task UnloadModule {
    if(Get-Module -Name 'MSOnlineExt'){ Remove-Module -Name 'MSOnlineExt' }
}
task UpdateManifest {
    $functions_path = Join-Path -Path ( Join-Path -Path ( Join-Path -Path $PSScriptRoot -ChildPath 'src' ) -ChildPath 'MSOnlineExt' ) -ChildPath 'Public'
    $manifest_path = Join-Path -Path ( Join-Path -Path ( Join-Path -Path $PSScriptRoot -ChildPath 'src' ) -ChildPath 'MSOnlineExt' ) -ChildPath 'MSOnlineExt.psd1'

    $functions = Get-ChildItem -Path $functions_path -Filter '*.ps1'
    $manifest_params = @{
        Path = $manifest_path
        Copyright = 'Copyright © {0} Dakota Clark. All rights reserved.' -f (Get-Date).Year
        FunctionsToExport = $functions.BaseName
        ModuleVersion = $env:APPVEYOR_BUILD_VERSION
    }
    Update-ModuleManifest @manifest_params
}
task . UnloadModule, Test