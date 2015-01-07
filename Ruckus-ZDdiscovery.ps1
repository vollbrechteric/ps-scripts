<# Configures network so that Ruckus ZoneFlex APs can more easily find Ruckus ZoneDirectors.

Run this script on a server with the DHCP and DNS role installed.
#>
$zdip = Read-Host -Prompt 'IP address of ZoneDirector?'
$zdfqdn = Read-Host -Prompt 'FQDN of the ZoneDirector?'
$zddomin = $zdfqdn -split '.', 0, 'simplematch'

#region DHCP Option 43 configuration
# TODO: Check if DHCP server role is installed. Fail if false.
# DHCP discovery with option 43
# setup vendor class of 'Ruckus CPE'
Add-DhcpServerv4Class -Data 'Ruckus CPE' -Name 'Ruckus CPE' -Type Vendor -Description 'Ruckus ZoneDirector discovery for APs'

# setup option 43
# Set predefined Options
# Assign to scope

#endregion DHCP Option 43 configuration

#region DNS hostname configuration
# TODO: Check if DNS role is already installed. If false fail.
# TODO: Check if record already exists. If true fail.
Resolve-DnsName -Name zonedirector

#endregion DNS hostname configuration
