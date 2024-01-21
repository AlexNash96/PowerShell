# This script was used to clean up large crash dumps regularly on an RDS server
# The purpose was to ensure the crash dumps would not take up too much disk space which was a limited resource on this server.
# Author: Alex Nash
set-location C:\users
$users = gci -Path .\
foreach($user in $users){
    gci -Path "C:\users\$($user.name)\appdata\local\microsoft\windows\wer\ReportQueue" -Include * -Recurse| foreach { $_.delete() }
}