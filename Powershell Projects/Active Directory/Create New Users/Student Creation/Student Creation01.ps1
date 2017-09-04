Import-Module ActiveDirectory

$Session_OnPremExch = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://dc-email-01.oakham.rutland.sch.uk/PowerShell/ -Authentication Kerberos -Credential $UserCredential
Import-PSSession $Session_OnPremExch

$SAM = "99997"
$UPN = "99997@oakham.rutland.sch.uk"
$Name = "99997"
$DisplayName = "pupil test"
$GivenName = "pupil"
$SurName = "test"
$Email = "99997@oakham.rutland.sch.uk"
$Description = "2024 Pupil"
$Department = "Peterborough House - AVP"
$Title = "2024"
$ProfilePath = "\\dc-fs\2024$\99997\profile"
$ScriptPath = "logon.bat"
$HomeDirectory = "\\dc-fs\2024$\99997"
$HomeDrive = "H"
$Path = "OU="+$Title+",OU=Pupils,OU=W7 Users,DC=oakham,DC=rutland,DC=sch,DC=uk"
$Password = "P@ssw0rd$" 

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

    Add-ADGroupMember "Pupils" $UPN

    # Create private directory
	New-Item -ItemType Directory -Path $HomeDirectory
    icacls $HomeDirectory /inheritance:d
	$ACL = (Get-ACL -Path $HomeDirectory)

    # Set Permissions
	$UserAccount = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"Oakham.rutland.sch.uk\$Name","Modify", "ContainerInherit, ObjectInherit", "None", "Allow"))
	$DomainAdmins = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"Oakham.rutland.sch.uk\Domain Admins","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
	$SYSTEM = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"SYSTEM","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
	$everyone = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"everyone","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))

    $FolderAccess = @($UserAccount, $DomainAdmins, $SYSTEM)

    foreach ($SecurityPerm in $FolderAccess) {
	$ACL.AddAccessRule($SecurityPerm)
    $ACL.RemoveAccessRuleAll($everyone)
	Set-ACL -Path $HomeDirectory $ACL
    }

    #Create Workspace
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Computing
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Chemistry
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Physics
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Biology
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\JuniorScience
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Religion
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Philosophy
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\PE
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Sports
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Art
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Design
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Textiles
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Classics
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Latin
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Italian
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\French
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\German
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Spanish
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Geography
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Maths
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\History
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\English
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Politics
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Business
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Economics
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\ToK
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\ExtendedEssay
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Citizenship
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Drama
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Music

    # Set Permissions

    icacls "\\dc-fs\pupil-files\WorkDropBox\$Title\$Name\" /inheritance:d
	$ACL = (Get-ACL -Path "\\dc-fs\pupil-files\WorkDropBox\$Title\$Name\")

	$UserAccount = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"Oakham.rutland.sch.uk\$Name","Modify", "ContainerInherit, ObjectInherit", "None", "Allow"))
	$DomainAdmins = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"Oakham.rutland.sch.uk\Domain Admins","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
    $AcademicStaff = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"Oakham.rutland.sch.uk\Domain Admins","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
	$SYSTEM = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"SYSTEM","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
	
    $Pupils = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"pupils","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
    $Staff = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"staff","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
    $everyone = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"everyone","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
    #$BUILTIN = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"BUILTIN","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
    $Administrators = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"Administrators","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))

    $AddAccess = @($UserAccount, $DomainAdmins, $SYSTEM, $AcademicStaff)

    foreach ($SecurityPerm in $AddAccess) {
	$ACL.AddAccessRule($SecurityPerm)
    $ACL.RemoveAccessRuleAll($everyone)
	Set-ACL -Path "\\dc-fs\pupil-files\WorkDropBox\$Title\$Name\" $ACL
    }

    $RemoveAccess = @($everyone, $staff, $Pupils, $Administrators)

    foreach ($SecurityPerm in $RemoveAccess) {
    $ACL.RemoveAccessRuleAll($SecurityPerm)
	Set-ACL -Path "\\dc-fs\pupil-files\WorkDropBox\$Title\$Name\" $ACL
    }

    # Point AD at O365 for mailbox & inform onpremise exchange of mailbox location
    Enable-RemoteMailbox -Identity $Name -RemoteRoutingAddress "$Name@oakham.mail.onmicrosoft.com"

    #Force delta sync cycle to ensure any changes made have been updated in AAD
    Invoke-Command -ComputerName dc-sec { Start-ADSyncSyncCycle -PolicyType Delta }

    # Wait for Delta Sync completion
    Start-Sleep -Seconds 120

    #Assign License
    Connect-MsolService
    Set-MsolUser -UserPrincipalName "$Name@oakham.rutland.sch.uk" -UsageLocation "GB"
    Set-MsolUserLicense -UserPrincipalName "$Name@oakham.rutland.sch.uk" -AddLicenses "oakham:STANDARDWOFFPACK_STUDENT", "oakham:OFFICESUBSCRIPTION_STUDENT"

    #preconfigure timezone and language
    #get-mailbox -Identity "99997@oakham.rutland.sch.uk" | Set-MailboxRegionalConfiguration -Language 2057  -TimeZone "GMT Standard Time"