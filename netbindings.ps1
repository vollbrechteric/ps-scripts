# disable or enable netowrk bindings
# Get the net adapters
Get-NetAdapter |
Out-GridView -Title 'Choose the adapter to make changes' -PassThru |
# Get the bindings for selected adapters
ForEach-Object { Get-NetAdapterBinding -Name $_.name } |
Out-GridView -PassThru -Title 'Choose bindings to disable or enable' |
# disable or enable network bindings
ForEach-Object { Disable-NetAdapterBinding -Name "$_.name" -ComponentID $_.ComponentID }