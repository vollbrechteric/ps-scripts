# http://social.technet.microsoft.com/wiki/contents/articles/6736.move-transfering-or-seizing-fsmo-roles-with-ad-powershell-command-to-another-domain-controller-en-us.aspx
#
# Import ActiveDirectory Modules
Import-Module -Name ActiveDirectory
#
# You can view FSMO role owner with this AD-Powershell commands:
#
Get-ADForest | Select-Object SchemaMaster,DomainNamingMaster
#
Get-ADDomain | Select-Object PDCEmulator,RIDMaster,InfrastructureMaster
#
# Moving the FSMO roles with the AD PowerShell has the following advantages:
#  1. It must not first connect to the future Domain Controller role holders are made.
#  2. Only the Seizing (role holder is offline) the FSMO roles will require an additional parameter, you must use -Force parameter.
#  3. Transfering or Seizing the FSMO roles must not necessarily the role holder or the future role holder be conducted. You can run AD-Powershell command from Windows 7 Client or Windows Server 2008 R2 memeber Server (after RSAT installed).
#
# The FSMO roles are moved using the Move-ADDirectoryServerOperationMasterRole to another Domain Controller.
#
# Transfering all roles, command syntax:
Move-ADDirectoryServerOperationMasterRole -Identity "Target-DC" -OperationMasterRole SchemaMaster,RIDMaster,InfrastructureMaster,DomainNamingMaster,PDCEmulator
#
# Seizing all roles, command syntax:
# Move-ADDirectoryServerOperationMasterRole -Identity "Target-DC" -OperationMasterRole SchemaMaster,RIDMaster,InfrastructureMaster,DomainNamingMaster,PDCEmulator -Force
#
# But instead of typing the Names of the operations master roles, Numbers may also be specified. 
# Here is table:
#
# Role Name            | Number
# PDCEmulator          | 0
# RIDMaster            | 1
# InfrastructureMaster | 2
# SchemaMaster         | 3
# DomainNamingMaster   | 4
#
# Transfering all roles, command syntax: 
# Move-ADDirectoryServerOperationMasterRole -Identity "Target-DC" -OperationMasterRole 0,1,2,3,4
#
# Seizing all roles, command syntax:
# Move-ADDirectoryServerOperationMasterRole -Identity "Target-DC" -OperationMasterRole 0,1,2,3,4 -Force