Import-Module ActiveDirectory

# Connect to O365
$username = "jpw@oakham.rutland.sch.uk"
$password = '"Sw0rdf1sh"'
$secureStringPwd = $password | ConvertTo-SecureString -AsPlainText -Force 
$UserCredential = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $secureStringPwd

# 365 connection
Connect-MsolService -Credential $UserCredential

# Exchange Online connection
$Session_O365 = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session_O365

# Exchange Onpremise connection
$Session_OnPremExch = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://dc-email-01.oakham.rutland.sch.uk/PowerShell/ -Authentication Kerberos -Credential $UserCredential
Import-PSSession $Session_OnPremExch


$Users = Import-Csv -Path "E:\Staff.csv"

foreach($User in $Users){

$SAM = $User.SAM
$UPN = $User.SAM+"@oakham.rutland.sch.uk"
$Name = $User.SAM
$DisplayName = $User.GivenName+" "+$User.SurName
$GivenName = $User.GivenName
$SurName = $User.SurName
$Email = "$SAM@oakham.rutland.sch.uk"
$Description = $User.Title+" Pupil"
$Department = $User.Department
$Title = $User.Title
$ProfilePath = "\\dc-fs\support$\$Name\profile"
$ScriptPath = "staff.bat"
$HomeDirectory = "\\dc-fs\support$\$Name"
$HomeDrive = "H"
$Path = "OU=Support,OU=Staff,OU=W7 Users,DC=oakham,DC=rutland,DC=sch,DC=uk"
$Password = "Orange_Year17" 

    # Create new user
    New-ADUser `
        -SamAccountName $SAM `
        -UserPrincipalName $UPN `
        -Name $Name `
        -DisplayName $DisplayName `
        -GivenName $GivenName `
        -SurName $SurName `
        -email $Email `
        -Description $Description `
        -Department $Department `
        -title $Title `
        -profilePath $ProfilePath `
        -scriptPath $ScriptPath `
        -HomeDirectory $HomeDirectory `
        -HomeDrive $HomeDrive `
        -Path $Path `
        -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -force) -PassThru

    Set-ADUser `
        -Identity $Name `
        -Enabled $True `
        -ChangePasswordAtLogon $True

    Add-ADGroupMember "Staff" $UPN

    # Create private directory
	New-Item -ItemType Directory -Path $HomeDirectory
    icacls $HomeDirectory /inheritance:d
	$ACL = (Get-ACL -Path $HomeDirectory)

    # Set Permissions
	$UserAccount = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"Oakham.rutland.sch.uk\$Name","Modify", "ContainerInherit, ObjectInherit", "None", "Allow"))
	$DesktopSupport = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"Oakham.rutland.sch.uk\Desktop Support Tech","Modify", "ContainerInherit, ObjectInherit", "None", "Allow"))
    $DomainAdmins = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"Oakham.rutland.sch.uk\Domain Admins","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
	$SYSTEM = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"SYSTEM","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
	
    $everyone = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"everyone","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
    $Staff = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"staff","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))


    $FolderAccess = @($UserAccount,$DesktopSupport, $DomainAdmins, $SYSTEM)

    foreach ($SecurityPerm in $FolderAccess) {
	$ACL.AddAccessRule($SecurityPerm)
    $ACL.RemoveAccessRuleAll($everyone)
    $ACL.RemoveAccessRuleAll($staff)
	Set-ACL -Path $HomeDirectory $ACL
    }

    # Point AD at O365 for mailbox & inform onpremise exchange of mailbox location
    Enable-RemoteMailbox -Identity $Name -RemoteRoutingAddress "$Name@oakham.mail.onmicrosoft.com"

    #Force delta sync cycle to ensure any changes made have been updated in AAD
    Invoke-Command -ComputerName dc-sec { Start-ADSyncSyncCycle -PolicyType Delta }

    # Wait for Delta Sync completion
    Start-Sleep -Seconds 30

    #Assign License
    Set-MsolUser -UserPrincipalName "$Name@oakham.rutland.sch.uk" -UsageLocation "GB"
    Set-MsolUserLicense -UserPrincipalName "$Name@oakham.rutland.sch.uk" -AddLicenses "oakham:STANDARDWOFFPACK_FACULTY", "oakham:OFFICESUBSCRIPTION_FACULTY", "oakham:POWER_BI_STANDARD", "oakham:CLASSDASH_PREVIEW"
}
