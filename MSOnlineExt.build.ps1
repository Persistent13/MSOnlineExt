task Deploy UpdateManifest, UnloadModule, LoadModule, Test, UnloadModule, StageModule, {
    if($env:APPVEYOR)
    {
        $deploy_path = "$PSScriptRoot\src\Deploy"
        if($env:APPVEYOR_REPO_BRANCH -eq 'Master')
        {
            Invoke-PSDeploy -Path $deploy_path -Force -Tags 'Test'
            Publish-Module -Name 'MSOnlineExt' -NuGetApiKey $env:NugetApiKey -Force
        }
        else
        {
            Invoke-PSDeploy -Path $deploy_path -Force -Tags 'Test'
        }
    }
    else
    {
        Write-Warning -Message 'The command "Invoke-Build -Task Deploy" should only be used on the CI server.'
    }
}
task StageModule {
    Copy-Item -Path "$PSScriptRoot\src\MSOnlineExt\" -Recurse -Destination 'C:\module\MSOnlineExt\'
    $env:PSModulePath += ';C:\module'
    Import-Module -Name 'MSOnlineExt'
}
task Test {
    $test_path = Join-Path -Path ( Join-Path -Path $PSScriptRoot -ChildPath 'src' ) -ChildPath 'Test'
    if ($env:APPVEYOR)
    {
        $test_file = 'TestResults_{0}_{1}.xml' -f $PSVersionTable.PSVersion.ToString(), (Get-Date -UFormat '%Y%m%d-%H%M%S')
        $out_file = Join-Path -Path $test_path -ChildPath $test_file
        Invoke-Pester -Path $test_path -OutputFormat 'NUnitXml' -OutputFile $out_file
        $wc = [System.Net.WebClient]::new()
        $upload_uri = 'https://ci.appveyor.com/api/testresults/nunit/{0}' -f $env:APPVEYOR_JOB_ID
        $wc.UploadFile($upload_uri,$out_file)
    }
    else
    {
        # Any tests not run from Appveyor
        Invoke-Pester -Path $test_path
    }
}
task LoadModule {
    $manifest_path = Join-Path -Path ( Join-Path -Path ( Join-Path -Path $PSScriptRoot -ChildPath 'src' ) -ChildPath 'MSOnlineExt' ) -ChildPath 'MSOnlineExt.psd1'
    if(-not ([appdomain]::CurrentDomain.GetAssemblies().FullName -match 'Microsoft.ApplicationInsights') -and -not $env:APPVEYOR)
    {
        $dll = Join-Path -Path ( Join-Path -Path ( Join-Path -Path ( Join-Path -Path $PSScriptRoot -ChildPath 'src' ) -ChildPath 'MSOnlineExt' ) -ChildPath 'Assembly' ) -ChildPath 'Microsoft.ApplicationInsights.dll'
        Add-Type -Path $dll
    }
    if (-not (Get-Module -Name 'MSOnlineExt'))
    {
        # Disable telmetry prompt on module import during tests
        $global:WarningPreference = 'SilentlyContinue'
        Import-Module $manifest_path
        $global:WarningPreference = 'Continue'
    }
}
task UnloadModule {
    if (Get-Module -Name 'MSOnlineExt'){ Remove-Module -Name 'MSOnlineExt' }
}
task UpdateManifest {
    $functions_path = Join-Path -Path ( Join-Path -Path ( Join-Path -Path $PSScriptRoot -ChildPath 'src' ) -ChildPath 'MSOnlineExt' ) -ChildPath 'Public'
    $manifest_path = Join-Path -Path ( Join-Path -Path ( Join-Path -Path $PSScriptRoot -ChildPath 'src' ) -ChildPath 'MSOnlineExt' ) -ChildPath 'MSOnlineExt.psd1'
    $module_root = Join-Path -Path ( Join-Path -Path $PSScriptRoot -ChildPath 'src' ) -ChildPath 'MSOnlineExt'
    Push-Location
    Set-Location -Path $module_root
    $dll = Get-ChildItem -File -Recurse -Filter '*.dll' | Resolve-Path -Relative
    $file_list = Get-ChildItem -File -Recurse | Resolve-Path -Relative | ForEach-Object { $PSItem.Substring(2) }
    Pop-Location

    $functions = Get-ChildItem -Path $functions_path -Filter '*.ps1'
    $manifest_params = @{
        CompanyName = 'Dakota Clark'
        Path = $manifest_path
        Copyright = 'Copyright © {0} Dakota Clark. All rights reserved.' -f (Get-Date).Year
        FunctionsToExport = $functions.BaseName
        ModuleVersion = $env:APPVEYOR_BUILD_VERSION
        RequiredAssemblies = $dll
        FileList = $file_list
    }
    Update-ModuleManifest @manifest_params
}
task . UnloadModule, LoadModule, Test
