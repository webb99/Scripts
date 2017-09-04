Restart-Computer Server01
restart-computer "server01","server02","server03" 
restart-computer (get-content c:\work\computers.txt)
restart-computer (get-content c:\work\computers.txt) -credential "catmosecollege\administrator"

"Log a user off"
Get-WmiObject win32_operatingsystem -ComputerName Quark | Invoke-WMIMethod -name Win32Shutdown
Get-WmiObject win32_operatingsystem -ComputerName Quark | Invoke-WMIMethod -name Win32Shutdown -ArgumentList @(4)