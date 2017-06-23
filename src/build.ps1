task Clean, Test, Deploy {
    $deploy = {
        Deploy Module {
            By PSGalleryModule {
                FromSource MSOnlineExt
                To PSGallery
                WithOptions @{
                    ApiKey = $env:NugetApiKey
                }
            }
        }
    }
    $deploy.Invoke()
}
task Test {
    $test_path = Join-Path -Path $PSScriptRoot -ChildPath 'Test'
    Invoke-Pester $test_path
}
task Clean {
    if(Get-Module -Name 'MSOnlineExt')
    {
        Remove-Module -Name 'MSOnlineExt'
    }
}
task . Clean, Test