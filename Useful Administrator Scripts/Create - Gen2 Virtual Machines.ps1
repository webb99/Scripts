<#
#####Creating VM's through powershell#####

To remotely create and manage vms you need to ensure that powershell remoting is enabled. 
This command shows you all commands to do with PS remoting. 
Get-Command *PSSession* 

To identify which command lines from Hyper-V can be used with the remote option computername
Get-Command –Module Hyper-V –ParameterName Computername

To enable remote connections to a machine
Enable-PSRemoting

To connect to a remote machine
Connect-PSSession Hostname

Get VM's and basic details
Get-VM | select -ExpandProperty NetworkAdapters | select VMName, SwitchName, IPAddresses

#>

# Set your variables here
# Enter the recomended resources for the type of server you wish to build or what is available on your system.
$VMName = "WSN16BTWBHV-001"
$VMGeneration = '2'
$VMBootDevice = 'CD'
$VMSwitchName = "VM - Internal LAN"
$VMMemoryStartupBytes = 1024MB #If Dynamic memory is disabled this is the only variable you require regarding memory.
$VMLocation = "E:\Hyper-V"

$CPUCount = 4
$CPUReserve = 0
$CPUMaximum = 80
$CPURelativeWeight = 100
 
$MEMMaximumBytes = 16384MB
$MEMMinimumBytes = 256MB
$MEMPriority = 25
$MEMBuffer = 25

$VMDiskSize = 100GB

$VMISO = "Z:\USB BKUP\ISOs\Microsoft\Windows Server\en_windows_server_2016_x64_dvd_9718492.iso"

    New-VM `
    -Name $VMName `
    -Generation $VMGeneration `
    -BootDevice $VMBootDevice `
    -SwitchName $VMSwitchName `
    -MemoryStartupBytes $VMMemoryStartupBytes `
    -Path $VMLocation `
    -NoVHD -Verbose

    Set-VMProcessor `
    -VMName $VMName `
    -Count $CPUCount `
    -Reserve $CPUReserve `
    -Maximum $CPUMaximum `
    -RelativeWeight $CPURelativeWeight

    Set-VMMemory `
    -VMName $VMName `
    -DynamicMemoryEnabled $True `
    -MaximumBytes $MEMMaximumBytes `
    -MinimumBytes $MEMMinimumBytes `
    -Priority $MEMPriority `
    -Buffer $MEMBuffer

    New-VHD `
    -Path "$VMLocation\$VMName\Virtual Hard Disks\$VMName-Disk1.vhdx" `
    -SizeBytes $VMDiskSize -Verbose

    Add-VMHardDiskDrive `
    -VMName $VMName `
    -Path "$VMLocation\$VMName\Virtual Hard Disks\$VMName-Disk1.vhdx" -Verbose

    Set-VMDvdDrive `
    -VMName $VMName `
    -Path $VMISO -Verbose

    #Start-VM -Name $VMName
    #VMConnect localhost $VMName

