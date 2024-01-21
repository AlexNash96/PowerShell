#This script checks for users whose password was set after the specified date
#Author: Alex Nash

$OU = Read-Host -Prompt "Enter the DN of the OU for to search:"
$users = Get-ADUser -searchbase $OU -Filter * -properties passwordlastset


foreach ($user in $users){

    if ($user.passwordlastset -gt (get-date 2020-08-24)){

        $user.name

    }

}