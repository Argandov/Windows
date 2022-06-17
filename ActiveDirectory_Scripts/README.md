# General AD Reference notebook

Scripts, commands, reference info.

---

# Initial setup Windows Server & Workstations
(Flight Checklist)
- Install [Chocolatey](https://chocolatey.org/install)
- [Debloat](https://github.com/ChrisTitusTech/win10script/blob/master/win10debloat.ps1) Windows 10

```powershell
# Using Choco to install tools (Git, vscode, etc)
choco install vscode
```
---

# Quick Jumpstart

```powershell
# Install ADDS (Customize):

Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainName "my.domain" `
-DomainNetbiosName "OPS" `
-ForestMode "WinThreshold" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true
```

# Members of the domain

Joining a domain:
* Execute sysdm.cpl -> Join, or: (Powershell) `Add-Computer -DomainName my.domain -Credential organization\User -Force -Restart`

