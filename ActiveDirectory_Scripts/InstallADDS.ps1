Enable-PSRemoting -Force
set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTS Connections" -Value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" -Value 1
Rename-Computer -ComputerName (hostname) -newname "MY-DC"

Set-TimeZone -Name ""

Import-Module ServerManager
Install-windowsfeature -name AD-Domain-Services –IncludeManagementTools
Install-WindowsFeature –Name GPMC
shutdown /f /r /t 1
