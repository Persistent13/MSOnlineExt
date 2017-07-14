Deploy MSOnlineExt {
    By AppVeyorModule {
        FromSource src\MSOnlineExt
        To AppVeyor
        Tagged Test
        WithOptions @{
            Version = $env:APPVEYOR_BUILD_VERSION
        }
    }
    By PSGalleryModule {
        FromSource C:\module\MSOnlineExt
        To PSGallery
        Tagged Prod
        WithOptions @{
            ApiKey = $env:NugetApiKey
        }
    }
}
