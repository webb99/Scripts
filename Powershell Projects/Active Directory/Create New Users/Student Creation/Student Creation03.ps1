<#

SYNOPSIS

  User Creation for Oakham School Students.

DESCRIPTION

  The script will create accounts in Active directory, create home and workdropbox folders, assign permissions,
  connect to onpremise exchange and enable the accounts remote mailbox it will then force a sync with Azure AD 
  before waiting 30 seconds to ensure completion. It will then assign licenses to the users in the csv.

PARAMETER <Parameter_Name>

  None currently used.

INPUTS

  Requires a CSV file containing necessary user information, headers formatted as beneath.

  SAM,Title,GivenName,SurName,Department,Password

  Various sections will need customising.
    i)        Credential details
    ii)       OnPremise mailserver web address
    iii)      Location of CSV
    iV)       Folder and OU Paths
    V)        AD Group memberships
    Vi)       Security Groups for folder permissions
    Vii)      Remoute routing address & domain address
    Viii)     AAD Sync Server name
    Viiii)    Licensing

OUTPUTS Log File

  The script log file stored in C:\Logs\UserCreation.log

NOTES

  Version:        4.0

  Author:         Jack Webb

  Creation Date:  04/08/2017

  Purpose/Change: 
  04/08/2017     Initial script development.
  14/08/2017     Added support for bulk user creation using csv.
  15/08/2017     Moved AAD Sync cycle out of foreach cycles to speed up script. Now takes place after all users have been created.
  25/08/2017     Fixed issue assigning user permissions to home folders.
  

KNOWN ISSUES

    i)     Unsecure Credentials used in script.
    ii)    During bulk creation random user folder permissions will fail to set correctly. Fixed 25/08/2017

THINGS TO DO
    
    i)    Set department correctly in script using house + tutor i.e. Clipshaw - HJS.
    ii)   Add users to groups based on department field.
    iii)  Add users to internet groups based on year/form.
    iV)   Reduce number of customisations required to use in different environments.
    v)    Collect variables into section so as to not repeat them throughout and make it easier to adjust.

#>


######################################################################
# LOAD MODULES & OPEN SESSIONS
######################################################################

# Connections 
$username = "jpw@oakham.rutland.sch.uk"
$password = '"Sw0rdf1sh"'
$secureStringPwd = $password | ConvertTo-SecureString -AsPlainText -Force 
$UserCredential = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $secureStringPwd
$Connection_ExchOnline = "https://outlook.office365.com/powershell-liveid/"
$Connection_ExchOnPremise = "http://dc-email-01.oakham.rutland.sch.uk/PowerShell/"

# AD PoSH Module
Import-Module ActiveDirectory

# 365 connection
Connect-MsolService -Credential $UserCredential

# Exchange Online connection
$Session_O365 = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $Connection_ExchOnline -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session_O365

# Exchange Onpremise connection
$Session_OnPremExch = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $Connection_ExchOnPremise -Authentication Kerberos -Credential $UserCredential
Import-PSSession $Session_OnPremExch

######################################################################
# IMPORT USERS
######################################################################

# Import user details
$Users = Import-Csv -Path ".\Source\Students.csv"

######################################################################
# CREATE USERS
# The variables set at the top of this section will need setting as 
# they are dependent upon the environment.
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

# Without pause sometimes causes issues with assigning user permissions on home folders.
Write-Output "Pauing for 45s to allow AD to finalise account creation"
Start-Sleep -Seconds 45

######################################################################
# CREATE USER HOME DIRECTORIES
######################################################################
foreach ($User in $Users){

    $Name = $User.SAM
    $UPN = $User.SAM+"@oakham.rutland.sch.uk"
    $HomeDirectory = "\\dc-fs\"+$User.Title+"$\"+$User.SAM
    $Title = $User.Title

    # Create private directory
    New-Item -ItemType Directory -Path $HomeDirectory -ErrorAction SilentlyContinue
    icacls $HomeDirectory /inheritance:d
	$ACL = (Get-ACL -Path $HomeDirectory)

    $YearGP = $Title
    $YearExamGP = $Title+"Exam"

    $UserAccount = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"$UPN","Modify", "ContainerInherit, ObjectInherit", "None", "Allow"))
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

    $UPN = $User.SAM+"@oakham.rutland.sch.uk"
    $Title = $User.Title
    $Name = $User.SAM

    #Create Workspace
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Computing -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Chemistry -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Physics -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Biology -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\JuniorScience -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Religion -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Philosophy -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\PE -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Sports -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Art -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Design -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Textiles -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Classics -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Latin -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Italian -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\French -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\German -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Spanish -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Geography -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Maths -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\History -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\English -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Politics -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Business -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Economics -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\ToK -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\ExtendedEssay -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Citizenship -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Drama -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path \\dc-fs\pupil-files\WorkDropBox\$Title\$Name\Music -ErrorAction SilentlyContinue
    icacls "\\dc-fs\pupil-files\WorkDropBox\$Title\$Name\" /inheritance:d
	$ACL = (Get-ACL -Path "\\dc-fs\pupil-files\WorkDropBox\$Title\$Name\")
    
    # Create Permissions
	$UserAccount = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"$UPN","Modify", "ContainerInherit, ObjectInherit", "None", "Allow"))
	$DomainAdmins = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"Oakham.rutland.sch.uk\Domain Admins","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
	$DesktopSupport = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"Oakham.rutland.sch.uk\Desktop Support Tech","Modify", "ContainerInherit, ObjectInherit", "None", "Allow"))
    $AcademicStaff = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"Oakham.rutland.sch.uk\Domain Admins","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
	$SYSTEM = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"SYSTEM","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
	
    $Pupils = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"pupils","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
    $Staff = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"staff","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
    $everyone = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"everyone","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
    $Administrators = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"Administrators","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))

    # Set Permissions
	$ACL.AddAccessRule($AcademicStaff)
	$ACL.AddAccessRule($DesktopSupport)
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
    $Name = $User.SAM
    Enable-RemoteMailbox -Identity $Name -RemoteRoutingAddress "$Name@oakham.mail.onmicrosoft.com"     
    
 }  
    
# Force delta sync cycle to ensure any changes made have been updated in AAD
Invoke-Command -ComputerName dc-sec { Start-ADSyncSyncCycle -PolicyType Delta }

# Wait for Delta Sync completion
Write-Output "Waiting 45s for AAD Sync Cycle to complete"
Start-Sleep -Seconds 45

######################################################################
# ASSIGN OFFICE 365 LICENSEING
######################################################################
foreach($User in $Users){
    $Name = $User.SAM+"@oakham.rutland.sch.uk"
    Set-MsolUser -UserPrincipalName $Name -UsageLocation "GB" -Verbose
    Set-MsolUserLicense -UserPrincipalName $Name -AddLicenses "oakham:STANDARDWOFFPACK_STUDENT", "oakham:OFFICESUBSCRIPTION_STUDENT", "oakham:POWER_BI_STANDARD" -Verbose

}

Remove-PSSession $Session_O365 -Verbose
Remove-PSSession $Session_OnPremExch -Verbose