#VARIABLES
$logpath = "C:\log\DCInstall.log"
$ipaddress = '10.1.10.30'
$prefixlength = '24'
$defaultgateway = '10.1.10.1'
$dnsserver = '127.0.0.1'
$interfacealias = 'Ethernet'

#CONFIGURE OS
#Set Computer Name
Rename-Computer -NewName WSC16BTWBHV-001 -Verbose –force

#Set IP Address
New-NetIPAddress `
    -IPAddress $ipaddress `
    -PrefixLength $prefixlength `
    -interfacealias $interfacealias `
    -DefaultGateway $defaultgateway

#Set DNS
Set-DnsClientServerAddress `
    -InterfaceIndex (Get-NetAdapter).ifIndex `
    -ServerAddresses $dnsserver

#Disable SMB1
Set-SmbServerConfiguration -EnableSMB1Protocol $False
Set-SmbServerConfiguration -EnableSMB2Protocol $True﻿
Remove-WindowsFeature -Name FS-SMB1 -Remove

#Disable IPv6
$nic = get-netadapter
Disable-NetAdapterBinding –InterfaceAlias $nic.name –ComponentID ms_tcpip6 -Verbose
Set-NetTeredoConfiguration -Type Disabled -Verbose
Set-NetIsatapConfiguration -State Disabled -Verbose
Set-Net6to4Configuration -State Disabled -Verbose

#Set High Performance
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 

#Install Roles
New-Item $logpath -ItemType File -Force -Verbose
Add-WindowsFeature -Name AD-Domain-Services -Verbose -LogPath $logpath
Add-WindowsFeature -Name DNS -Verbose -LogPath $logpath
Add-WindowsFeature -Name DHCP –IncludeManagementTools -Verbose -LogPath $logpath
Add-WindowsFeature -Name GPMC -Verbose -LogPath $logpath

Restart-Computer -Force
