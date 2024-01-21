<# This script was built over time to expedite configuring AD users. The script copies attributes and appropriate group memberships,
Sets a phone number if it is known in advance, sets RDS settings in AD, and allows remote access. The end of the script sets up the necessary folders for RDS use.
Author: Alex Nash
#>

$olduser = Read-Host -prompt 'Enter username of User to copy attributes from:'
$newuser = Read-Host -prompt 'Enter username of new user"'
$phone = Read-Host -prompt 'Enter the new users phone number:'
$domain = Read-Host -Prompt 'Enter the name of the domain:'

$groups = get-aduser $olduser -properties memberof | select -expandproperty memberof
$user = Get-ADUser $olduser -Properties office,description,streetaddress,state,postalcode,city,department,country,fax,title,company,manager,msnpallowdialin,officephone
$new = Get-ADUser $newuser -Properties *

foreach ($group in $groups) {

	Add-ADGroupMember -Identity $group $newuser

}

Set-ADUser $newuser -Office $user.office -Description $user.description -Department $user.department -StreetAddress $user.streetaddress -State $user.state -PostalCode $user.postalcode -City $user.city -Country $user.country -Fax $user.fax -Title $user.title -Company $user.company -Manager $user.manager

if($phone){
Set-ADUser $newuser -OfficePhone $phone
}

Set-ADUser -Identity $new.SamAccountName -Replace @{msnpallowdialin=$true}

$TSProfilePath = Read-Host -Prompt "Enter the path to the Terminal Services profile store:"
$TSHomeDirectory = Read-Host -Prompt "Enter the path to the Terminal Services Home Directory:"
$x = [ADSI]"LDAP://$($new.distinguishedname)"
$x.psbase.InvokeSet("terminalservicesprofilepath","$($TSProfilePath)\$($newuser)")
$x.psbase.InvokeSet("terminalserviceshomedrive","H:")
$x.psbase.InvokeSet("terminalserviceshomedirectory","$($TSHomeDirectory)\$($newuser)")
$x.psbase.InvokeSet("maxidletime","120")
$x.psbase.InvokeSet("maxdisconnectiontime","15")
$x.setinfo()

#THe follow code creates the RDS profile folders with necessary permissions
#This is done by the script because setting the path with powershell does not create the folders and permissions
#Without creating setting the permissions, users will have issues
$RDSProfilePath = Read-Host -Prompt "Enter the path to the RDS profile store:"
mkdir "$($RDSProfilePath)\$($new.samaccountname)"
$rule = new-object System.Security.AccessControl.FileSystemAccessRule ("$($domain)\$($new.samaccountname)","FullControl","ContainerInherit, ObjectInherit","none","Allow")
$acl = Get-Acl "$($RDSProfilePath)\$($new.samaccountname)"
$acl.SetAccessRule($rule)
set-acl "$($RDSProfilePath)\$($new.samaccountname)" -AclObject $acl