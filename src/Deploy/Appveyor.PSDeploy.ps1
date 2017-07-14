Deploy MSOnlineExt {
    By AppVeyorModule {
        FromSource src\MSOnlineExt
        To AppVeyor
        Tagged Test
        WithOptions @{
            Version = $env:APPVEYOR_BUILD_VERSION
        }
    }
}
