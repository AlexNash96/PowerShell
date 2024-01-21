<#
This script is written to move a copy of the month end database to archive storage and is intended to run as a scheduled task.
Author: Alex Nash
#>

Start-Transcript -Path C:\scripts\archive.log
$Server = <Server name> 
$SourcePath = <Source Path>
$DestinationPath = <Destination Path>

$today = Get-Date
ping $server        # the appliance used for archive storage required a ping in advance to wake up
switch ($today.Month-1){ #determines month of database (month before script runs)
0 {$month = 'Dec'}
1 {$month = 'Jan'}
2 {$month = 'Feb'}
3 {$month = 'Mar'}
4 {$month = 'Apr'}
5 {$month = 'May'}
6 {$month = 'Jun'}
7 {$month = 'Jul'}
8 {$month = 'Aug'}
9 {$month = 'Sep'}
10 {$month = 'Oct'}
11 {$month = 'Nov'}
}



<# checks if the month of the DB is December, then sets year to previous year #>
if ($month -eq "Dec"){
    $year = $today.Year-1
} else {
    $year = $today.Year
}
timeout 30      # added time to allow the server to wake up
Copy-Item -Path "$($SourcePath)\$($month) $($year).bak" -Destination "$($DestinationPath)\$($month) $($year).bak"
stop-transcript