#requires -version 4.0
<#
        Created by Eric Vollbrecht vollbrechteric@hotmail.com

        https://github.com/vollbrechteric/ps-scripts

        Desired State Configurtion script to configure WatchGuard Dimension server on Microsoft Hyper-V 2016.

#>

configuration WGDimension
{
    # One can evaluate expressions to get the node list
    # E.g: $AllNodes.Where("Role -eq Web").NodeName
    node $AllNodes.Where{$_.Role -eq 'WebServer'}.NodeName
    {
        # Call Resource Provider
        # E.g: WindowsFeature, File
        WindowsFeature HyperV
        {
            Ensure = 'Present'
            Name = 'Hyper-V'
        }

        File FriendlyName
        {
            Ensure = 'Present'
            SourcePath = $SourcePath
            DestinationPath = $DestinationPath
            Type = 'Directory'
            DependsOn = '[WindowsFeature]FriendlyName'
        }
        
        
    }
}

# ConfigurationName -configurationData <path to ConfigurationData (.psd1) file>
