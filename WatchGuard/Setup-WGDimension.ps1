#requires -Modules BitsTransfer, Hyper-V, NetAdapter, ServerManager
#requires -version 5.0
<#
        Created by Eric Vollbrecht vollbrechteric@hotmail.com

        https://github.com/vollbrechteric/ps-scripts

        All of the steps needed to create a new WatchGuard Dimension server in MS Hyper-V 2008 R2 or newer.

        This script is intended to run from the local server where Dimension will be stored.

        Once thc script completes check DHCP server for IP address of new VM and connect to via HTTPS and use the default credentials.
#>
param
(
    [Parameter( Position = 0 )]
    # HelpMessage = 'Location of install file on the internet'
    [String] $uri = 'http://cdn.watchguard.com/SoftwareCenter/Files/WSM/Dimension_2_1_1_U1/watchguard-dimension_2_1_1_U1_vhd.zip',

    [Parameter( Position = 1 )]
    # 'Destination for the downloaded file'
    [String] $downloaddest = ("$env:USERPROFILE\downloads"),

    [Parameter( Position = 2 )]
    # 'Name of new vswitch that will be created.  Can use existing'
    [String] $vswitch = 'WG vSwitch',

    [Parameter( Position = 3 )]
    # 'Use Get-NetAdapter to determine the adapter name'
    [String] $nic = ( Get-NetAdapter -Physical | Where-Object -FilterScript {
            $_.ConnectorPresent -EQ 'True' -AND $_.PhysicalMediaType -EQ '802.3' 
    } ), 

    [Parameter( Position = 4 )]
    # 'Path to where the VM config will be stored'
    [String] $vmpath = ('C:\vm\Dimension\'),

    [Parameter( Position = 5 )]
    # 'Path to the .vhd file from WG'
    [String] $bootvhd = 'watchguard-dimension_2_1_1_U1.vhd', 

    [Parameter( Position = 6 )]
    # 'Name of the VM'
    [String] $vmname = 'WG_Dimension',

    [Parameter( Position = 7 )]
    # 'Path to where new virtual data drive will be stored'
    [String] $datavhd = 'data.vhdx',

    [Switch] $SkipDownload

)
# 
# Update when download address changes
$download = "$downloaddest\watchguard-dimension_2_1_1_U1_vhd.zip"
#
# Check if Hyper-V is installed
if ( (Get-WindowsFeature -Name 'Hyper-V').Installed -eq $false )
{
    Install-WindowsFeature -Name 'Hyper-V' -IncludeAllSubFeature
}
#
# If command line switch specifed skip the download
if ( $SkipDownload ) 
{
    $null
}
# Test path and if file exists skip downloading the file
elseif ( ( Test-Path -Path "$vmpath\$bootvhd" ) -eq $false )
{    
    # Create folder for VM
    New-Item -ItemType directory -Path "$vmpath"
    # Download the file from WatchGuard.
    Start-BitsTransfer -Source $uri -Destination $downloaddest  -TransferType Download
    # Extract file. If the DestinaationPath does not exist it is automatically created.
    Expand-Archive -Path $download -DestinationPath $vmpath
}
# Create a new vmswitch in Hyper-V
New-VMSwitch -Name $vswitch -NetAdapterName $nic.ifAlias -Notes 'Switch created for WG Dimension server VM'
#
# Create the new VM
New-VM -Name $vmname -VHDPath ( $vmpath + $bootvhd ) -SwitchName $vswitch -MemoryStartupBytes 2GB -Path $vmpath
#
# Create data vhd
New-VHD -Path ( $vmpath + $datavhd ) -SizeBytes 200GB -Dynamic
#
# Connect a new data vhd to the new VM
Add-VMHardDiskDrive -VMName $vmname -Path ( $vmpath + $datavhd ) -ControllerType IDE -ControllerNumber 0 
#
# Boot the VM
Start-VM -Name $vmname
#
# End of script