#This script will output the Windows key used to activate the machine it is run on if the key is available
(Get-WmiObject -query 'select * from SoftwareLicensingService').OA3xOriginalProductKey
$host.UI.RawUI.ReadKey()
