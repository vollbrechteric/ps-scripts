<#PSScriptInfo
        .VERSION 1.0
        .GUID b1e04006-2ff1-4a72-a631-cc887231172e
        .AUTHOR Eric Vollbrecht
        .COMPANYNAME 
        .COPYRIGHT 
        .DESCRIPTION Create a new WatchGuard Dimension server in MS Hyper-V 2008 R2 or newer.
        .TAGS WatchGuard 
        .LICENSEURI 
        .PROJECTURI https://github.com/vollbrechteric/ps-scripts
        .ICONURI 
        .EXTERNALMODULEDEPENDENCIES BitsTransfer Hyper-V NetAdapter ServerManager
        .REQUIREDSCRIPTS 
        .EXTERNALSCRIPTDEPENDENCIES 
        .RELEASENOTES
#>

#requires -Modules BitsTransfer, Hyper-V, NetAdapter, ServerManager -version 5.0

<#
        .SYNOPSIS
        All of the steps needed to create a new WatchGuard Dimension server in MS Hyper-V 2008 R2 or newer.

        .DESCRIPTION
        Long description

        .PARAMETER URI
        Location of install file on the WatchGuard website. Update this when WatchGuard releases a new version.

        .PARAMETER DownloadDest
        Destination for the downloaded file.

        .PARAMETER VSwitch
        Name of new vswitch that will be created or the existing switch that the VM will be connected to.

        .PARAMETER NIC
        Network Adapter that the VSwitch will be connected to. By default the first physical connection is selected.

        .PARAMETER VMPath
        Path to where the VM config will be stored.

        .PARAMETER BootVHD
        Path to the .vhd file from WatchGuard.

        .PARAMETER VMName
        Name of the VM. Default is WG_Dimension.

        .PARAMETER DataVHD
        Path to where new virtual data drive will be stored.

        .PARAMETER SkipDownload
        Switch to prevent skip trying to download the install file from WatchGuard. 

        .EXAMPLE
        >> .\Setup-WGDimension

        .EXAMPLE
        >> .\Setup-WGDimension -SkipDownload

        .NOTES
        Created by Eric Vollbrecht vollbrechteric@hotmail.com
        This script is intended to run from the local server where Dimension will be stored.
        Once the script completes check DHCP server for IP address of new VM and connect to via HTTPS and use the default credentials.

        .LINK
        https://github.com/vollbrechteric/ps-scripts

#>

param
(
    [Parameter( Position = 0 )]
    [String] $URI = 'http://cdn.watchguard.com/SoftwareCenter/Files/WSM/Dimension_2_1_1_U2/watchguard-dimension_2_1_1_U2_vhd.zip',

    [Parameter( Position = 1 )]
    [String] $DownloadDest = ("$env:USERPROFILE\downloads"),

    [Parameter( Position = 2 )]
    [String] $VSwitch = 'WG vSwitch',

    [Parameter( Position = 3 )]
    $NIC = ( Get-NetAdapter -Physical | Where-Object -FilterScript {
            $_.ConnectorPresent -EQ 'True' -AND $_.PhysicalMediaType -EQ '802.3'
    } ), 

    [Parameter( Position = 4 )]
    [String] $VMPath = ('C:\vm\Dimension\'),

    [Parameter( Position = 5 )]
    [String] $BootVHD = 'watchguard-dimension_2_1_1_U2.vhd', 

    [Parameter( Position = 6 )]
    [String] $VMName = 'WG_Dimension',

    [Parameter( Position = 7 )]
    [String] $DataVHD = 'data.vhdx',

    [Switch] $SkipDownload

)
# 
# Update when download address changes
$download = "$DownloadDest\watchguard-dimension_2_1_1_U2_vhd.zip"
#
# Check if Hyper-V is installed
<#if ( (Get-WindowsFeature -Name 'Hyper-V').Installed -eq $false )
        {
        Install-WindowsFeature -Name 'Hyper-V' -IncludeAllSubFeature
        }
#>
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