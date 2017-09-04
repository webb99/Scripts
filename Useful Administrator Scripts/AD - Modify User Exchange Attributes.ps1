Import-Module ActiveDirectory

#Write-Output "Please input User Principal Name"

$user = 'JAT'

Get-ADUser -Identity $user -Properties homeMDB | Set-ADUser -Clear homeMDB 
Get-ADUser -Identity $user -Properties homeMTA | Set-ADUser -Clear homeMTA 
Get-ADUser -Identity $user -Properties msExchHomeServername | Set-ADUser -Clear msExchHomeServerName
Get-ADUser -Identity $user -Properties msExchRecipientDisplayType | Set-ADUser -Replace @{msExchRecipientDisplayType="-2147483642"}
Get-ADUser -Identity $user -Properties msExchRecipientTypeDetails | Set-ADUser -Replace @{msExchRecipientTypeDetails="2147483648"}
Get-ADUser -Identity $user -Properties mail | Set-ADUser -Replace @{mail="$user@oakham.rutland.sch.uk"}
#Get-ADUser -Identity $user -Properties proxyAddresses | Set-ADUser -Replace @{proxyAddresses="$user@oakham.rutland.sch.uk"} 
Get-ADUser -Identity $user -Properties targetAddress | Set-ADUser -Replace @{targetAddress="$user@oakham.mail.onmicrosoft.com"} 


'reset back to what was, may need to change staff to student on homeMDB'

$ruser = 'JAT'

Get-ADUser -Identity $ruser -Properties homeMDB | Set-ADUser -Replace @{homeMDB='CN=Staff Mailbox,CN=Databases,CN=Exchange Administrative Group (FYDIBOHF23SPDLT),CN=Administrative Groups,CN=Catmose College,CN=Microsoft Exchange,CN=Services,CN=Configuration,DC=catmosecollege,DC=com'}
Get-ADUser -Identity $ruser -Properties homeMTA | Set-ADUser -Replace @{homeMTA='CN=Microsoft MTA,CN=CC-EXCHMB1,CN=Servers,CN=Exchange Administrative Group (FYDIBOHF23SPDLT),CN=Administrative Groups,CN=Catmose College,CN=Microsoft Exchange,CN=Services,CN=Configuration,DC=catmosecollege,DC=com'} 
Get-ADUser -Identity $ruser -Properties msExchHomeServername | Set-ADUser -Replace @{msExchHomeServerName='/o=Oakham School/ou=Exchange Administrative Group (FYDIBOHF23SPDLT)/cn=Configuration/cn=Servers/cn=DC-EMAIL-01'}
Get-ADUser -Identity $ruser -Properties msExchRecipientDisplayType | Set-ADUser -Replace @{msExchRecipientDisplayType="1073741824"}
Get-ADUser -Identity $ruser -Properties msExchRecipientTypeDetails | Set-ADUser -Replace @{msExchRecipientTypeDetails="1"} 
Get-ADUser -Identity $ruser -Properties targetAddress | Set-ADUser -Replace @{targetAddress="$ruser@oakham.mail.onmicrosoft.com"} 




Enable-RemoteMailbox -Identity jat -RemoteRoutingAddress "jat@oakham.mail.onmicrosoft.com"

Get-MsolUser -ReturnDeletedUsers | Remove-MsolUser -RemoveFromRecycleBin -Force






Get-RemoteMailbox JAT@oakham.rutland.sch.uk | Format-List ExchangeGUID
Get-Mailbox JAT@oakham.rutland.sch.uk | Format-List ExchangeGUID
Set-RemoteMailbox JAT@oakham.rutland.sch.uk  -ExchangeGuid 76748dad-7b3c-45e1-a41f-a57fecaaf460


[guid]$guid = "76748dad-7b3c-45e1-a41f-a57fecaaf460"

get-Aduser “JAT” | set-aduser -Replace @{msExchArchiveguid='76748dad-7b3c-45e1-a41f-a57fecaaf460'}
get-Aduser “JAT” | set-aduser -Replace @{msExchArchiveguid=$guid.tobytearray()}