#VARIABLES
$logpath = "C:\log\DCInstall.log"
$ipaddress = '10.1.10.30'
$prefixlength = '24'
$defaultgateway = '10.1.10.1'
$dnsserver = '127.0.0.1'
$interfacealias = 'Ethernet'

#CONFIGURE OS
#Set Computer Name
#Rename-Computer -NewName WSC16BTWBHV-001 -Verbose –force

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