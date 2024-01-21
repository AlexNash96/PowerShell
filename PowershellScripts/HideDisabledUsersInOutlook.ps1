# This script is used to find any disabled users in AD and hide them in the Outlook GAL.
# If necessary, the -searchbase parameter can be used on line 5 to only look at OUs containing users.
# Author: Alex Nash

$users = get-aduser -filter {enabled -eq $false}

#hide in address book

foreach($user in $users){
    set-aduser $user -replace @{msExchHideFromAddressLists=$True}
    set-aduser $user -Clear showinaddressbook
}