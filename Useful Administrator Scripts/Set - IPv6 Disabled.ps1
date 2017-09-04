$nic = get-netadapter
Disable-NetAdapterBinding –InterfaceAlias $nic.name –ComponentID ms_tcpip6 -Verbose
Set-NetTeredoConfiguration -Type Disabled -Verbose
Set-NetIsatapConfiguration -State Disabled -Verbose
Set-Net6to4Configuration -State Disabled -Verbose
