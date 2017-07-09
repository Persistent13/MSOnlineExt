Deploy MSOnlineExt {
    By AppVeyorModule {
        FromSource MSOnlineExt
        To AppVeyor
        WithOptions @{
            Version = $env:APPVEYOR_BUILD_VERSION
        }
    }
}
