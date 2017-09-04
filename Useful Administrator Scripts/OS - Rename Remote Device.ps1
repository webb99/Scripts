#Changes the name of the computer you enter.  Prompts for admin credentials- include the domain name #when you put cred in.
#Prompts for whether or not you want to restart the renamed computer imeadiately- changes do not take effect #until restart.


$TargetComp=Read-Host -Prompt "Enter the Name of the Computer you want to change the name of "
$Credential=Get-Credential
$computerName = GWMI Win32_ComputerSystem -computername $TargetComp -Authentication 6
Write-host "Current Computer Name is " $computerName
$name = Read-Host -Prompt "Please Enter the ComputerName you want to use."
Write-host "New Computer Name " $Name
$Go=Read-Host -prompt "Proceed with computer name change? (Y / N)"
If(($Go-eq"Y")-or($Go-eq"y"))
{
$computername.Rename($name,$credential.GetNetworkCredential().Password,$credential.Username)
}
$Reboot=Read-host -Prompt "Do you want to restart the computer? (Y / N)"
If(($Reboot-eq"Y")-or($Reboot-eq"y"))
{
restart-computer -computername $TargetComp
}

# Rename-Computer Name with PowerShell
Clear-Host
$CSVFile ="D:\Experiment\RenameComp.csv"
$List = Import-Csv $CSVFile -Header OldName, NewName
Foreach ($Machine in $List) {
Rename-Computer -NewName $Machine.NewName `
-Computer $Machine.OldName -Force -Restart 
}