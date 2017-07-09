Deploy MSOnlineExt {
    By AppVeyorModule {
        FromSource src\MSOnlineExt
        To AppVeyor
        WithOptions @{
            Version = $env:APPVEYOR_BUILD_VERSION
        }
    }
}
