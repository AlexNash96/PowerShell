# This was the initial script to clean up Toshiba caches that were bloated. See ToshibaCacheCleanup.ps1 for more details
# Author: Alex Nash

$users = Get-ChildItem -Path "C:\users" -Name

foreach ($user in $users){

    Remove-Item -Path "C:\users\$($user)\TOSHIBA" -Recurse

}