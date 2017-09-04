#VARIABLES
$SiteName = "homelab"
$DRSMPass = "dR3c0_v3r7"

$DatabasePath = "C:\Windows\NTDS" 
$LogPath = "C:\Windows\NTDS" 
$SysvolPath = "C:\Windows\SYSVOL" 

$DomainName = "homelab.local"
$NetBIOSName = "homelab"
$DomainMode = "WinThreshold"
$ForestMode = "WinThreshold"

$Account = "homelab.local\administrator"
$Password = ConvertTo-SecureString -String "L0caladm1n" -AsPlainText -Force
$Credential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $Account, $Password


$tsenv = New-Object -COMObject Microsoft.SMS.TSEnvironment
$tsenv.Value("NameofVariable")

$TSConfigureAD = $tsenv.Value("TSConfigureAD")

Switch ($TSConfigureAD) 
    { 
        1 {
        # Creating New Forest - First Domain Controller
        Import-Module ADDSDeployment
        Install-ADDSForest `
            -CreateDnsDelegation:$false `
            -DatabasePath $DatabasePath `
            -SafeModeAdministratorPassword (ConvertTo-SecureString $DRSMPass -AsPlainText -force) `
            -DomainMode $DomainMode `
            -DomainName $DomainName `
            -DomainNetbiosName $NetBIOSName `
            -ForestMode $ForestMode `
            -InstallDns:$true `
            -LogPath $LogPath `
            -NoRebootOnCompletion:$false `
            -SysvolPath $SysvolPath `
            -Force:$true
        } 
        2 {
        #Add Domain Controller to existing domain
        Import-Module ADDSDeployment
        Install-ADDSDomainController `
            -AllowDomainControllerReinstall:$true `
            -NoGlobalCatalog:$false `
            -CreateDnsDelegation:$false `
            -Credential (Get-Credential -Credential $Credential) `
            -CriticalReplicationOnly:$false `
            -DatabasePath $DatabasePath `
            -SafeModeAdministratorPassword (ConvertTo-SecureString $DRSMPass -AsPlainText -force) `
            -DomainName $DomainName `
            -InstallDns:$true `
            -LogPath $LogPath `
            -NoRebootOnCompletion:$false `
            -SiteName $SiteName `
            -SysvolPath $SysvolPath `
            -Force:$true
        } 
        3 {
        #Add Domain Controller to existing domain
        #Read Only Domain Controller
        Import-Module ADDSDeployment
        Install-ADDSDomainController `
            -AllowDomainControllerReinstall:$true `
            -NoGlobalCatalog:$false `
            -Credential (Get-Credential -Credential $Credential) `
            -CriticalReplicationOnly:$false `
            -DatabasePath $DatabasePath `
            -SafeModeAdministratorPassword (ConvertTo-SecureString $DRSMPass -AsPlainText -force) `
            -DomainName $DomainName `
            -InstallDns:$true `
            -LogPath $LogPath `
            -NoRebootOnCompletion:$false `
            -ReadOnlyReplica:$true `
            -SiteName $SiteName `
            -SysvolPath $SysvolPath `
            -Force:$true
        } 
        default {
        }
    }

#Set Stale State of SYSVOL to 16 years
#wmic.exe /namespace:\\root\microsoftdfs path DfsrMachineConfig set MaxOfflineTimeInDays=6000

