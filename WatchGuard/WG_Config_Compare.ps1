#requires -version 4.0
<#
Created by Eric Vollbrecht vollbrechteric@hotmail.com

https://github.com/vollbrechteric/ps-scripts

Compare a WatchGuard xml confige file to call out items that are not best practice.

#>

# Path to config
Set-Variable -Name wd -Description 'Working directory where xml files are located' -Value "$HOME\Documents\my watchguard\configs"

# The reference config
$ref = [xml]( Get-Content -Path "$wd\XTM26-W.xml" )

# The difference config that is being compared to the reference
$dif = [xml]( Get-Content -Path "$wd\XTM26-W.xml" )

# The compare
Compare-Object -ReferenceObject $ref -DifferenceObject $dif