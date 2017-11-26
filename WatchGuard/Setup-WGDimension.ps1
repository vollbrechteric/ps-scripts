#requires -Modules BitsTransfer, Hyper-V
#requires -version 2.0
<#
        Created by Eric Vollbrecht vollbrechteric@hotmail.com

        https://github.com/vollbrechteric/ps-scripts

        All of the steps needed to create a new Dimension server in MS Hyper-V 2008 R2 or newer.

        This script is intended to run from the local server where Dimension will be stored
        extract .zip file
        copy files to c:\vm\dimension

        TODO: Check hash with get-filehash or see if it can be done with a method

        TODO: Unzip file
#>
param
(
    [Parameter( Position = 0 )]
    # HelpMessage = 'Location of install file on the internet'
    [String] $uri = 'http://cdn.watchguard.com/SoftwareCenter/Files/WSM/Dimension_2_0_U2/watchguard-dimension_2_1_1_U1_vhd.zip',

    [Parameter( Position = 1 )]
    # 'Destination for the downloaded file'
    [String] $downloaddest = ("$env:USERPROFILE\downloads"),

    ##[Parameter( Position = 2 )]
    # 'Folder for virtual machine'
    ##[String] $vmfolder = 'c:\vm\dimension',

    [Parameter( Position = 3 )]
    # 'Name of new vswitch that will be created.  Can use existing'
    [String] $vswitch = 'vswitch1',

    [Parameter( Position = 4 )]
    # 'Use Get-NetAdapter to determine the adapter name'
    [String] $nic = 'Ethernet 3', 

    [Parameter( Position = 5 )]
    # 'Path to where the VM config will be stored'
    [String] $vmpath = ('C:\vm\Dimension\'),

    [Parameter( Position = 6 )]
    # 'Path to the .vhd file from WG'
    [String] $bootvhd = 'watchguard-dimension_2_1_1_U1.vhd', 

    [Parameter( Position = 7 )]
    # 'Name of the VM'
    [String] $vmname = 'WG_Dimension',

    [Parameter( Position = 8 )]
    # 'Path to where new virtual data drive will be stored'
    [String] $datavhd = 'data.vhdx',

    [Switch] $SkipDownload

)
# 
# TODO: Test path and if file exists skip downloading the file
if ( "$vmpath\$bootvhd" -eq $false)
{
    # Download the file
    Start-BitsTransfer -Source $uri -Destination $downloaddest  -TransferType Download
    # Extract file
    Expand-Archive -Path $downloaddest -DestinationPath $vmpath 
}
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
#
# end of script