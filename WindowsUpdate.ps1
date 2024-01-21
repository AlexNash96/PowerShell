#Simple script run as a scheduled task to install updates on windows servers.
#This was implented to reduce time spent on admin tasks in small team
#Author: Alex Nash
Get-WindowsUpdate -Install -AcceptAll -AutoReboot