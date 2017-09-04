Import-Module ActiveDirectory

$Session_OnPremExch = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://dc-email-01.oakham.rutland.sch.uk/PowerShell/ -Authentication Kerberos -Credential $UserCredential
Import-PSSession $Session_OnPremExch

    # Create new user
    New-ADUser `
        -SamAccountName "99998" `
        -UserPrincipalName "99998@oakham.rutland.sch.uk" `
        -Name "99998" `
        -DisplayName "pupil test" `
        -GivenName "pupil" `
        -SurName "test" `
        -email "99998@oakham.rutland.sch.uk" `
        -Description "2024 Pupil" `
        -Department "Peterborough House - AVP" `
        -title "2024" `
        -profilePath "\\dc-fs\2024$\99998\profile" `
        -scriptPath "logon.bat" `
        -HomeDirectory "\\dc-fs\2024$\99998" `
        -HomeDrive "H" `
        -Path "OU=2024,OU=Pupils,OU=W7 Users,DC=oakham,DC=rutland,DC=sch,DC=uk" `
        -AccountPassword (ConvertTo-SecureString P@ssw0rd -AsPlainText -force) -PassThru

    Set-ADUser `
        -Identity 99998 `
        -Enabled $True `
        -ChangePasswordAtLogon $True

    Add-ADGroupMember "Pupils" 99998@oakham.rutland.sch.uk

    # Create private directory
	New-Item -ItemType Directory -Path "\\dc-fs\2024$\99998"
    icacls "\\dc-fs\2024$\99998" /inheritance:d
	$ACL = (Get-ACL -Path "\\dc-fs\2024$\99998")

    # Set Permissions
	$UserAccount = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"Oakham.rutland.sch.uk\99998","Modify", "ContainerInherit, ObjectInherit", "None", "Allow"))
	$DomainAdmins = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"Oakham.rutland.sch.uk\Domain Admins","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
	$SYSTEM = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"SYSTEM","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
	$everyone = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"everyone","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))

    $FolderAccess = @($UserAccount, $DomainAdmins, $SYSTEM)

    foreach ($SecurityPerm in $FolderAccess) {
	$ACL.AddAccessRule($SecurityPerm)
    $ACL.RemoveAccessRuleAll($everyone)
	Set-ACL -Path "\\dc-fs\2024$\99998" $ACL
    }

    #Create Workspace
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99998
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99998\Computing
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99998\Chemistry
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99998\Physics
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99998\Biology
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99998\JuniorScience
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99998\Religion
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99998\Philosophy
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99998\PE
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99998\Sports
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99998\Art
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99998\Design
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99998\Textiles
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99998\Classics
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99998\Latin
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99998\Italian
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99998\French
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99998\German
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99998\Spanish
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99998\Geography
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99998\Maths
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99998\History
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99998\English
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99998\Politics
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99998\Business
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99998\Economics
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99998\ToK
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99998\ExtendedEssay
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99998\Citizenship
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99998\Drama
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99998\Music

    # Set Permissions

    icacls "\\dc-fs\pupil-files\WorkDropBox\2024\99998\" /inheritance:d
	$ACL = (Get-ACL -Path "\\dc-fs\pupil-files\WorkDropBox\2024\99998\")

	$UserAccount = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"Oakham.rutland.sch.uk\99998","Modify", "ContainerInherit, ObjectInherit", "None", "Allow"))
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
	Set-ACL -Path "\\dc-fs\pupil-files\WorkDropBox\2024\99998\" $ACL
    }

    $RemoveAccess = @($everyone, $staff, $Pupils, $Administrators)

    foreach ($SecurityPerm in $RemoveAccess) {
    $ACL.RemoveAccessRuleAll($SecurityPerm)
	Set-ACL -Path "\\dc-fs\pupil-files\WorkDropBox\2024\99998\" $ACL
    }

    # Point AD at O365 for mailbox & inform onpremise exchange of mailbox location
    Enable-RemoteMailbox -Identity 99998 -RemoteRoutingAddress "99998@oakham.mail.onmicrosoft.com"

    #Force delta sync cycle to ensure any changes made have been updated in AAD
    Invoke-Command -ComputerName dc-sec { Start-ADSyncSyncCycle -PolicyType Delta }

    # Wait for Delta Sync completion
    Start-Sleep -Seconds 120

    #Assign License
    Connect-MsolService
    Set-MsolUser -UserPrincipalName "99998@oakham.rutland.sch.uk" -UsageLocation "GB"
    Set-MsolUserLicense -UserPrincipalName "99998@oakham.rutland.sch.uk" -AddLicenses "oakham:STANDARDWOFFPACK_STUDENT", "oakham:OFFICESUBSCRIPTION_STUDENT"

    #preconfigure timezone and language
    #get-mailbox -Identity "99998@oakham.rutland.sch.uk" | Set-MailboxRegionalConfiguration -Language 2057  -TimeZone "GMT Standard Time"