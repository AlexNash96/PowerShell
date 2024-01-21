<#
This script acted as a temporary fix on RDS servers where Toshiba MFP drivers were creating bloated caches that over consumed disc space.
By ensuring the folder existed and setting the ACL to to ensure users and system did not have access I was able to prevent the bloat from occuring.
Author: Alex Nash
#>

$users = Get-ChildItem -Path C:\users
$SampleACLPath = <path>
$acl = (Get-Item $SampleACLPath).GetAccessControl('Access')

foreach ($user in $users) {

    If(Test-path C:\users\$($user)\TOSHIBA){
    } Else {
        md C:\Users\$($user)\TOSHIBA
    }

    If(Test-Path "C:\users\$($user)\TOSHIBA\estudiox\unidrv\cache"){

        Remove-Item -Path "C:\users\$($user)\TOSHIBA\estudiox\unidrv\cache" -Recurse -Force #clears bloated cache

    }

    Set-Acl -Path "C:\users\$($user)\Toshiba" -AclObject $acl

}