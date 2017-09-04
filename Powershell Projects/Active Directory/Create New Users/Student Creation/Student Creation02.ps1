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

# Import user details
$Users = Import-Csv -Path "E:\Students.csv"


######################################################################
# CREATE USERS
######################################################################

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
    $ProfilePath = "\\dc-fs\"+$User.Title+"$\"+$User.SAM+"\profile"
    $ScriptPath = "logon.bat"
    $HomeDirectory = "\\dc-fs\"+$User.Title+"$\"+$User.SAM
    $HomeDrive = "H"
    $Path = "OU="+$User.Title+",OU=Pupils,OU=W7 Users,DC=oakham,DC=rutland,DC=sch,DC=uk"
    $Password = $User.Password 

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
        -ChangePasswordAtLogon $False

    Add-ADGroupMember "Pupils" $SAM
    Add-ADGroupMember "fmsPupils" $SAM
    Add-ADGroupMember "Full Pupil List" $SAM
    Add-ADGroupMember "$Title" $SAM
}


######################################################################
# CREATE USER HOME DIRECTORIES
######################################################################
foreach ($User in $Users){

    $Name = $Users.SAM

    Write-Output $Name

    $HomeDirectory = "\\dc-fs\"+$User.Title+"$\"+$User.SAM
    $Title = $User.Title

    # Create private directory
	New-Item -ItemType Directory -Path $HomeDirectory
    icacls $HomeDirectory /inheritance:d
	$ACL = (Get-ACL -Path $HomeDirectory)

    $YearGP = $Title
    $YearExamGP = $Title+"Exam"

    # Create Permissions
	$UserAccount = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"Oakham.rutland.sch.uk\$Name","Modify", "ContainerInherit, ObjectInherit", "None", "Allow"))

    Write-Output $UserAccount

	$DomainAdmins = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"Oakham.rutland.sch.uk\Domain Admins","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
	$DesktopSupport = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"Oakham.rutland.sch.uk\Desktop Support Tech","Modify", "ContainerInherit, ObjectInherit", "None", "Allow"))
	$SYSTEM = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"SYSTEM","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
	$everyone = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"everyone","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
   	$Year = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]$YearGP,"FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
	$YearExam = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]$YearExamGP,"FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))

    # Set Permissions
	$ACL.AddAccessRule($UserAccount)
    $ACL.AddAccessRule($DomainAdmins)
    $ACL.AddAccessRule($DesktopSupport)
    $ACL.AddAccessRule($SYSTEM)

    $ACL.RemoveAccessRuleAll($Year)
    $ACL.RemoveAccessRuleAll($YearExam)
    $ACL.RemoveAccessRuleAll($everyone)
	Set-ACL -Path $HomeDirectory $ACL
}

######################################################################
# CREATE USER WORK DROPBOX DIRECTORIES
######################################################################
foreach ($User in $Users){
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
    icacls "\\dc-fs\pupil-files\WorkDropBox\$Title\$Name\" /inheritance:d
	$ACL = (Get-ACL -Path "\\dc-fs\pupil-files\WorkDropBox\$Title\$Name\")
    
    # Create Permissions
	$UserAccount = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"Oakham.rutland.sch.uk\$Name","Modify", "ContainerInherit, ObjectInherit", "None", "Allow"))
	$DomainAdmins = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"Oakham.rutland.sch.uk\Domain Admins","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
    $AcademicStaff = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"Oakham.rutland.sch.uk\Domain Admins","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
	$SYSTEM = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"SYSTEM","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
	
    $Pupils = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"pupils","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
    $Staff = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"staff","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
    $everyone = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"everyone","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
    $Administrators = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"Administrators","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))

    # Set Permissions
	$ACL.AddAccessRule($AcademicStaff)
	$ACL.AddAccessRule($UserAccount)
    $ACL.AddAccessRule($DomainAdmins)
    $ACL.AddAccessRule($SYSTEM)

    $ACL.RemoveAccessRuleAll($everyone)
    $ACL.RemoveAccessRuleAll($staff)
    $ACL.RemoveAccessRuleAll($Pupils)
    $ACL.RemoveAccessRuleAll($everyone)
    $ACL.RemoveAccessRuleAll($Administrators)
	Set-ACL -Path "\\dc-fs\pupil-files\WorkDropBox\$Title\$Name\" $ACL  

}

######################################################################
# CREATE USER REMOTE ROUTING ADDRESS
######################################################################

foreach($User in $Users){

    # Point AD at O365 for mailbox & inform onpremise exchange of mailbox location
    Enable-RemoteMailbox -Identity $Name -RemoteRoutingAddress "$Name@oakham.mail.onmicrosoft.com"     
    
 }  
    
# Force delta sync cycle to ensure any changes made have been updated in AAD
Invoke-Command -ComputerName dc-sec { Start-ADSyncSyncCycle -PolicyType Delta }

# Wait for Delta Sync completion
Start-Sleep -Seconds 60

######################################################################
# ASSIGN OFFICE 365 LICENSEING
######################################################################
foreach($User in $Users){
    $Name = $User.SAM+"@oakham.rutland.sch.uk"
    Set-MsolUser -UserPrincipalName $Name -UsageLocation "GB"
    Set-MsolUserLicense -UserPrincipalName $Name -AddLicenses "oakham:STANDARDWOFFPACK_STUDENT", "oakham:OFFICESUBSCRIPTION_STUDENT"
}

Remove-PSSession $Session_O365
Remove-PSSession $Session_OnPremExch
