# Run command on remote computer
Invoke-Command -ComputerName cc-mgmt3 -ScriptBlock {Start-ADSyncSyncCycle -PolicyType Delta} -Credential jw.admin

# Enter PoSH session on server
Enter-PSSession -ComputerName cc-mgmt3 -Credential jw.admin