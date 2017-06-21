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
    Invoke-Pester $PSScriptRoot\Test
}
task Clean {
    if(Get-Module -Name 'MSOnline-Extensions')
    {
        Remove-Module -Name 'MSOnline-Extensions'
    }
}
task . Clean, Test