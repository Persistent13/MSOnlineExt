Deploy MSOnlineExt {
    By AppVeyorModule {
        FromSource ( Join-Path -Path ( Split-Path -Path $PSScriptRoot -Parent ) -ChildPath 'MSOnlineExt' )
        To AppVeyor
        WithOptions @{
            Version = $env:APPVEYOR_BUILD_VERSION
        }
    }
}
