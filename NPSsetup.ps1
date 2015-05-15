<#
Configure Windows AD with RADIUS

1.	Install Network Policy Server role.
2.	Open NPS and navigate to Radius Clients and Server > Radius Clients.
3.	Right click Radius Clients and select New.
4.	Friendly Name: ZoneDirector
    Address: IP of ZoneDirector
5.	Select Manual for Shared Secret.  Input and confirm the secret key.
6.	Navigate to Policies > Network Policies.
7.	Right click Network Policies and select New.
8.	Input wireless policy for the name.
9.	For Conditions click Add… 
10.	Select User Groups and click Add...  Then Add Groups… Input the Security Group that’s been created for wireless.  Click OK.  Click Next.
11.	Leave it on Access Granted and click Next.
12.	For EAP types, add PEAP and EAP-MSCHAP v2.
13.	Uncheck all items except for PAP, SPAP.  Click Next
Note: Click No on the box that pops up
14.	On the Configure Restraints window, leave all defaults and click Next.
15.	At the Configure Settings window, leave all defaults and click Next.
16.	Click Finish.

Configuring the ZoneDirector:
1.	Log in to the ZoneDirector as an admin.
2.	Click on AAA Servers.
3.	Click Create New.
4.	Name: DomainName-RADIUS
    Type: RADIUS
    Encryption: Leave unchecked
    Auth Method: PAP
    Backup RADIUS: Leave unchecked
    IP Address: Input the IP of the server running NPS
    Port: Leave default
    Shared Secret: Input secret key set up on the server
5.	Click OK.
6.	Run a test on the bottom by selecting the DomainName-RADIUS server and inputting the credentials of a user which is in the Security Group which is allowed in the Network Policy on the server.
    Note: If it fails, check the NPS events by going into Server Manager.  Be sure to enable informational events.
7.	Edit the WLAN to use 802.1x EAP with WPA2 encryption.  Select the DomainName-RADIUS server on the bottom for the authentication server.

#>
