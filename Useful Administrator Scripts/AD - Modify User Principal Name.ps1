$OldName = 
$NewName =

$User = Get-ADUser -Identity $OldName -Properties displayName,homeDirectory,profilePath,mailNickname,name,sAMAccountName,userPrincipalName,mail,proxyAddresses,targetAddress
$User.displayName = 
$User.name = $NewName
$User.sAMAccountName = $NewName
$User.userPrincipalName = "$NewName@oakham.rutland.sch.uk"
$User.homeDirectory = "\\dc-fs\support$\$NewName"
$User.profilePath = "\\dc-fs\support$\$NewName\Profile"
$User.mailNickname = $NewName
$User.mail = @{mail ="$NewName@oakham.rutland.sch.uk"}
$User.proxyAddresses = @{proxyAddresses="$NewName@oakham.rutland.sch.uk"}
$User.targetAddress = @{targetAddress="$NewName@oakham.mail.onmicrosoft.com"} 

Set-ADUser -Instance $User













Get-ADUser -Identity $User -Properties mail | Set-ADUser -Replace @{mail="$User@oakham.rutland.sch.uk"}
Get-ADUser -Identity $User -Properties proxyAddresses | Set-ADUser -Replace @{proxyAddresses="$User@oakham.rutland.sch.uk"} 
Get-ADUser -Identity $User -Properties targetAddress | Set-ADUser -Replace @{targetAddress="$User@oakham.mail.onmicrosoft.com"} 