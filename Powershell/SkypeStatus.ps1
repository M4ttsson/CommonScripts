Param
	(
	[parameter(Mandatory=$false, Position=0,
	HelpMessage="3500 available, 15500 away, 6500 Busy, 9500 Do not disturb, 12000 Be Right Back")]
	[alias("Major")]
	[int]
	$availabilityCode=15500


	)

# Solution found here
# https://stackoverflow.com/questions/16213916/change-status-of-lync-by-script

# Credits to Pete
#https://stackoverflow.com/a/26316217

import-module "C:\Program Files (x86)\Microsoft Office\Office15\LyncSDK\Assemblies\Desktop\Microsoft.Lync.Controls.Dll"
import-module "C:\Program Files (x86)\Microsoft Office\Office15\LyncSDK\Assemblies\Desktop\Microsoft.Lync.Model.Dll"




$client = [Microsoft.Lync.Model.LyncClient]::GetClient()

$self = $client.Self

$currentStatus = $self.Contact.GetContactInformation("Availability")

# ändra inte ifall i möte eller do not disturb
if($currentStatus -eq 6500 -or $currentStatus -eq 9500)
{
    exit
}

#Set Details of Personal Note and Availability
#Useful availability codes for use below - 3500 Available, 15500 Away, 6500 Busy, 9500 Do not disturb, 12000 Be Right Back)
#$availability = 15500 

$contactInfo = new-object 'System.Collections.Generic.Dictionary[Microsoft.Lync.Model.PublishableContactInformationType, object]'
$contactInfo.Add([Microsoft.Lync.Model.PublishableContactInformationType]::Availability, 
            $availabilityCode)

$ar = $self.BeginPublishContactInformation($contactInfo, $null, $null)
$self.EndPublishContactInformation($ar)