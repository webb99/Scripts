Import-Module ActiveDirectory

$Session_OnPremExch = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://dc-email-01.oakham.rutland.sch.uk/PowerShell/ -Authentication Kerberos -Credential $UserCredential
Import-PSSession $Session_OnPremExch

   #-Office `
   #-company `

    # Create new user
    New-ADUser `
        -SamAccountName "99999" `
        -UserPrincipalName "99999@oakham.rutland.sch.uk" `
        -Name "99999" `
        -DisplayName "pupil test" `
        -GivenName "pupil" `
        -SurName "test" `
        -email "99999@oakham.rutland.sch.uk" `
        -Description "2024 Pupil" `
        -Department "Peterborough House - AVP" `
        -title "2024" `
        -profilePath "\\dc-fs\2024$\99999\profile" `
        -scriptPath "logon.bat" `
        -HomeDirectory "\\dc-fs\2024$\99999" `
        -HomeDrive "H" `
        -Path "OU=2024,OU=Pupils,OU=W7 Users,DC=oakham,DC=rutland,DC=sch,DC=uk" `
        -AccountPassword (ConvertTo-SecureString P@ssw0rd -AsPlainText -force) -PassThru
	-OtherAttributes @{'ItemPrice'=123; 'favColors'="red","blue"}

    Set-ADUser `
        -Identity 99999 `
        -Enabled $True `
        -ChangePasswordAtLogon $True

    Add-ADGroupMember "Pupils" 99999@oakham.rutland.sch.uk

    # Create private directory
	New-Item -ItemType Directory -Path "\\dc-fs\2024$\99999"
    icacls "\\dc-fs\2024$\99999" /inheritance:d
	$ACL = (Get-ACL -Path "\\dc-fs\2024$\99999")

    # Set Permissions
	$UserAccount = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"Oakham.rutland.sch.uk\99999","Modify", "ContainerInherit, ObjectInherit", "None", "Allow"))
	$DomainAdmins = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"Oakham.rutland.sch.uk\Domain Admins","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
	$SYSTEM = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"SYSTEM","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
	$everyone = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"everyone","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))

    $FolderAccess = @($UserAccount, $DomainAdmins, $SYSTEM)

    foreach ($SecurityPerm in $FolderAccess) {
	$ACL.AddAccessRule($SecurityPerm)
    $ACL.RemoveAccessRuleAll($everyone)
	Set-ACL -Path "\\dc-fs\2024$\99999" $ACL
    }

    #Create Workspace
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99999
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99999\Computing
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99999\Chemistry
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99999\Physics
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99999\Biology
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99999\JuniorScience
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99999\Religion
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99999\Philosophy
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99999\PE
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99999\Sports
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99999\Art
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99999\Design
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99999\Textiles
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99999\Classics
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99999\Latin
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99999\Italian
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99999\French
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99999\German
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99999\Spanish
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99999\Geography
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99999\Maths
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99999\History
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99999\English
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99999\Politics
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99999\Business
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99999\Economics
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99999\ToK
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99999\ExtendedEssay
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99999\Citizenship
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99999\Drama
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\2024\99999\Music

    # Set Permissions

    icacls "\\dc-fs\pupil-files\WorkDropBox\2024\99999\" /inheritance:d
	$ACL = (Get-ACL -Path "\\dc-fs\pupil-files\WorkDropBox\2024\99999\")

	$UserAccount = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"Oakham.rutland.sch.uk\99999","Modify", "ContainerInherit, ObjectInherit", "None", "Allow"))
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
	Set-ACL -Path "\\dc-fs\pupil-files\WorkDropBox\2024\99999\" $ACL
    }

    $RemoveAccess = @($everyone, $staff, $Pupils, $Administrators)

    foreach ($SecurityPerm in $RemoveAccess) {
    $ACL.RemoveAccessRuleAll($SecurityPerm)
	Set-ACL -Path "\\dc-fs\pupil-files\WorkDropBox\2024\99999\" $ACL
    }

    # Point AD at O365 for mailbox & inform onpremise exchange of mailbox location
    Enable-RemoteMailbox -Identity 99999 -RemoteRoutingAddress "99999@oakham.rutland.sch.uk"

    #Force delta sync cycle to ensure any changes made have been updated in AAD
    Invoke-Command -ComputerName dc-sec { Start-ADSyncSyncCycle -PolicyType Delta }

    # Wait for Delta Sync completion
    Start-Sleep -Seconds 120

    #Assign License
    Connect-MsolService
    Set-MsolUserLicense -UserPrincipalName "99999@oakham.rutland.sch.uk" -AddLicenses "oakham:STANDARDWOFFPACK_STUDENT", "OFFICESUBSCRIPTION_STUDENT" 