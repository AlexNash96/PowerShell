# This script was run as a scheduled task to reduce the frequency of manually removing old WSUS updates.
# Author: Alex Nash

Start-Transcript -Path C:\ScriptLog\WSUScleanup.log
Import-Module updateservices
Invoke-WsusServerCleanup -CleanupObsoleteUpdates
Stop-Transcript