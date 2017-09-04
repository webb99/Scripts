#VARIABLES
$DomainName = "homelab.local"
$DNSServerIP = "10.1.10.30"
$DHCPServerIP = "10.1.10.30"
$StartRange = "10.1.10.150"
$EndRange = "10.1.10.200"
$Subnet = "255.255.255.0"
$Router = "10.1.10.1"


#CONFIGURE DHCP
Add-DhcpServerSecurityGroup -ComputerName $Env:COMPUTERNAME
Set-DhcpServerDnsCredential -ComputerName $Env:COMPUTERNAME -Credential homelab.local\administrator 
Add-DhcpServerV4Scope -Name "DHCP Scope" -StartRange $StartRange -EndRange $EndRange -SubnetMask $Subnet
Set-DhcpServerV4OptionValue -DnsDomain $DomainName -DnsServer $DNSServerIP -Router $Router				
Add-DhcpServerInDC -DnsName $Env:COMPUTERNAME