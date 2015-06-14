#requires -version 4.0
<#
Created by Eric Vollbrecht vollbrechteric@hotmail.com

https://github.com/vollbrechteric/ps-scripts

Compare a WatchGuard xml confige file to call out items that are not best practice.

#>

# Path to config
Set-Variable -Name wd -Description 'Working directory where xml files are located' -Value "$HOME\Documents\my watchguard\configs"

# The parent config
$parent = [xml]( Get-Content "$wd\XTM26-W.xml" )

# The child config
$child = [xml]( Get-Content "$wd\XTM26-W.xml" )