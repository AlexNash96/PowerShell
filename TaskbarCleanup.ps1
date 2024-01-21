# This script was written to remove old Citrix Receiver shortcuts from users' taskbars through the whole domain when we upgraded to Citrix Workspace
# Author: Alex Nash

$users = Get-ChildItem C:\users

foreach ($user in $users) {

    Remove-Item "C:\users\$($user.name)\appdata\roaming\microsoft\internet explorer\quick launch\user pinned\taskbar\Citrix Receiver.lnk"

}