# Setup the Actual Domain & Forest

$domainname = "black.ops.com"
$NTDPath = "C:\Windows\ntds"
$logPath = "C:\Windows\ntds"
$sysvolPath = "C:\Windows\Sysvol"
$domainmode = "win2012R2"
$forestmode = "win2012R2"

Install-ADDSForest -CreateDnsDelegation:$false \
  -DatabasePath $NTDPath \
  -DomainMode $domainmode \
  -DomainName $domainname \
  -ForestMode $forestmode \
  -InstallDns:$true \
  -LogPath $logPath \
  -NoRebootOnCompletion:$false \
  -SysvolPath $sysvolPath \
  -Force:$true
