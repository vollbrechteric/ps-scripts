#requires -version 4.0
<#
Created by Eric Vollbrecht vollbrechteric@hotmail.com

https://github.com/vollbrechteric/ps-scripts

Get network adapters and then netbindings based on selection.
Flip the setting from true to false or false to true

TODO: setup the if..then

TODO: Error handling
#>
# Get the net adapters
Get-NetAdapter |
Out-GridView -Title 'Choose the adapter(s) to change' -PassThru |
# Get the bindings for selected adapters
ForEach-Object { Get-NetAdapterBinding -Name $_.name } |
Out-GridView -PassThru -Title 'Choose bindings to disable or enable' |
# disable or enable network bindings
ForEach-Object { Disable-NetAdapterBinding -Name "$_.name" -ComponentID $_.ComponentID }