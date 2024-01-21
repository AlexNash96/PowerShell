# With the windowsupdate module installed this script allowed updates to be scheduled and installed on servers.
# This was implemented with staggered updates to servers so that less critical servers were patched first.
# Patching non-critical servers first allowed updates to be screened so we could disable this task on other servers if something was broken
# Author: Alex Nash
Import-Module windowsupdate
Get-WindowsUpdate -Install -AcceptAll -AutoReboot