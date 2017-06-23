task Clean, Test, Deploy {
    $deploy = {
        Deploy Module {
            By PSGalleryModule {
                FromSource MSOnline-Extensions
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
    if(Get-Module -Name 'MSOnline-Extensions')
    {
        Remove-Module -Name 'MSOnline-Extensions'
    }
}
task . Clean, Test