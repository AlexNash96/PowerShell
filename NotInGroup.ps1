#This script was used to check for users that were not a member of a Security group that was meant to conatin all users.
#Author: Alex Nash

$groupname = Read-Host -Prompt "Enter the name of the group that should contain all users:"
$results = @()
$users = Get-ADUser  -Properties memberof -Filter * 
foreach ($user in $users) {
    $groups = $user.memberof -join ';'
    $results += New-Object psObject -Property @{'User'=$user.name;'Groups'= $groups}
    }
$results | Where-Object { $_.groups -notmatch $groupname } | Select-Object user