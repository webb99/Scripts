Connect-MsolService


$new_staff = Import-Csv "C:\Book1.csv" 
$old_domain = '@catmosecollege.com'
$cloud_domain = '@catmosecollege.onmicrosoft.com'
$new_domain = '@haringtonschool.com'


ForEach ($user in $new_staff) { 
    
    Set-MsolUserPrincipalName -UserPrincipalName "$user+'@'+$old_domain" -NewUserPrincipalName "$user+'@'+$cloud_domain"

    Set-MsolUserPrincipalName -UserPrincipalName "$user+'@'+$cloud_domain" -NewUserPrincipalName "$user+'@'+$new_domain"
}