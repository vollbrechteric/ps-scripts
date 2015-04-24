#requires -version 4.0
#
# All of the steps needed to create a new Dimension server in MS Hyper-V
# This script is intended to run from the local server where Dimension will be stored
# extract .zip file
# copy files to c:\vm\dimension
#
# TODO: Check hash with get-filehash or see if it can be done with a method
#
# TODO: Unzip file
#
$uri = 'http://cdn.watchguard.com/SoftwareCenter/Files/WSM/Dimension_1_3_U2/watchguard-dimension_1_3_U2_vhd.zip'   # location of file on internet
$vswitch = 'vswitch1'   # name of new vswitch that will be created.  Can use existing
$nic = 'Ethernet 3'   # use Get-NetAdapter to determine the adapter name
$vmpath = 'C:\vm\Dimension\'   # Path to where the VM config will be stored
$bootvhd = 'watchguard-dimension_1_3_U2.vhd'  # Path to the .vhd file from WG
$vmname = 'WG_Dimension'   # name of the VM
$datavhd = 'data.vhdx'   # path where new virtual data drive will be stored
# 
# Test path and if file exists skip downloading the file
# 
# Download the file
Start-BitsTransfer -Source $uri -Destination  -TransferType Download
#
# create new vmswitch
New-VMSwitch -Name $vswitch -NetAdapterName $nic
#
# create the new VM
New-VM -Name $vmname -VHDPath ( $vmpath + $bootvhd ) -SwitchName $vswitch -MemoryStartupBytes 2GB -Path $vmpath
#
# create data vhd
New-VHD -Path ( $vmpath + $datavhd ) -SizeBytes 40GB -Dynamic
#
# connect data vhd to vm
Add-VMHardDiskDrive -VMName $vmname -Path ( $vmpath + $datavhd ) -ControllerType IDE -ControllerNumber 0 
#
# boot vm
Start-VM -Name $vmname
