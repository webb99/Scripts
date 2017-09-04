<#

SYNOPSIS

  User Creation for Oakham School Staff.

DESCRIPTION

  The script will create accounts in Active directory, create home, assign permissions,
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
  25/08/2017     Fixed issue assigning user permissions to folder causing users to have no permissions on home folders.

KNOWN ISSUES

    i)     Unsecure Credentials used in script.
    ii)    During bulk creation random user folder permissions will fail to set correctly. Fixed 25/08/2017

THINGS TO DO
    
    i)    Add users to groups based on department.
    ii)   Reduce number of customisations required to use in different environments.
    iii)  Collect variables into section so as to not repeat them throughout and make it easier to adjust.
    iV)   Dynamic Path/Homedirectory location based on staff member i.e support & academic  

#>


######################################################################
# LOAD MODULES & OPEN SESSIONS
######################################################################

# Connections 
$username = "jpw@oakham.rutland.sch.uk"
$password = '"passw0rd"'
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
Write-Output "Pauing for 45s to allow AD to finalise account creation"
$Users = Import-Csv -Path ".\Source\Staff.csv"

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
    $Description = $User.Title
    $Department = $User.Department
    $Title = $User.Title
    $ProfilePath = "\\dc-fs\support$\$Name\profile"
    $ScriptPath = "staff.bat"
    $HomeDirectory = "\\dc-fs\support$\$Name"
    $HomeDrive = "H"
    $Path = "OU=Support,OU=Staff,OU=W7 Users,DC=oakham,DC=rutland,DC=sch,DC=uk"
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

    Add-ADGroupMember "Staff" $SAM
}

# Without pause sometimes causes issues with assigning user permissions on home folders.
Start-Sleep -Seconds 45

######################################################################
# CREATE USER HOME DIRECTORIES
######################################################################
foreach ($User in $Users){

    $Name = $User.SAM
    $UPN = $User.SAM+"@oakham.rutland.sch.uk"
    $HomeDirectory = "\\dc-fs\support$\"+$User.SAM
    $Title = $User.Title

    # Create private directory
    New-Item -ItemType Directory -Path $HomeDirectory -ErrorAction SilentlyContinue
    icacls $HomeDirectory /inheritance:d
	$ACL = (Get-ACL -Path $HomeDirectory)

    $UserAccount = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"$UPN","Modify", "ContainerInherit, ObjectInherit", "None", "Allow"))
	$DomainAdmins = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"Oakham.rutland.sch.uk\Domain Admins","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
	$DesktopSupport = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"Oakham.rutland.sch.uk\Desktop Support Tech","Modify", "ContainerInherit, ObjectInherit", "None", "Allow"))
	$SYSTEM = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"SYSTEM","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
	$everyone = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"everyone","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))

    # Set Permissions
    $ACL.AddAccessRule($UserAccount)
    $ACL.AddAccessRule($DomainAdmins)
    $ACL.AddAccessRule($DesktopSupport)
    $ACL.AddAccessRule($SYSTEM)

    $ACL.RemoveAccessRuleAll($everyone)
	Set-ACL -Path $HomeDirectory $ACL
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
    Set-MsolUserLicense -UserPrincipalName "$Name@oakham.rutland.sch.uk" -AddLicenses "oakham:STANDARDWOFFPACK_FACULTY", "oakham:OFFICESUBSCRIPTION_FACULTY", "oakham:POWER_BI_STANDARD", "oakham:CLASSDASH_PREVIEW" -Verbose

}

Remove-PSSession $Session_O365 -Verbose
Remove-PSSession $Session_OnPremExch -Verbose