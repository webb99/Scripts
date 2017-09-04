Set-SmbServerConfiguration -EnableSMB1Protocol $False -Force
Set-SmbServerConfiguration -EnableSMB2Protocol $True -Force
Remove-WindowsFeature -Name FS-SMB1 -Remove