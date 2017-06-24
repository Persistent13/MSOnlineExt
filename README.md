[![Build status](https://ci.appveyor.com/api/projects/status/h0j9auihbwfox3f0/branch/master?svg=true)](https://ci.appveyor.com/project/Persistent13/msonlineext/branch/master)

# MSOnlineExt

This PowerShell module was made to ease the burden of Azure AD management in single and multi-tenant environments by addressing the gaps found in interactive use.

# Installation

This module has dependancies on the MSOnline module and the `Register-ArgumentCompleter` command.

MSOnline is avaiable in the Gallery and can be installed with the command `Install-Module -Name MSOnline` when running as admin or `Install-Module -Name MSOnline -Scope CurrentUser` if not.

The command `Register-ArgumentCompleter` is available starting in PowerShell version 5.0.

# Usage

To load the module simply run `Import-Module -Name MSOnlineExt`

**NOTE:** In order for the autocompletion to work you must run `Connect-MsolService`

## Features

### Functions

- **Set-MsolTenantContext** - This command will set the default tenant ID for all MSOnline cmdlets allowing you to run them with out needing to specify the tenant ID each time.

- **Remove-MsolTenantContext** - This command will remove the set default tenant ID returning you to the default behavior.

- **Get-MsolTenantContext** - This command will return the currently set default tenant ID, if any. If the default tenant ID has not been set an empty GUID of `00000000-0000-0000-0000-000000000000` will be returned.

### Auto-Completion

Auto-completers are PowerShell ScriptBlocks that provide Intellisense & tab-completion for PowerShell command parameter values. These functions require the presence of the `Register-ArgumentCompleter` PowerShell command, which is available in PowerShell version 5.0.

This module provides auto completion for the following `MSOnline` parameters.

- AppPrincipalId
- DeviceId
- DomainName
- Feature
- SubscriptionId
- TenantId
- UserPrincipalName