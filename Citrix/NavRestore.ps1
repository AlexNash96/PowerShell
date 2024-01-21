<#
This script automatically restores and renames a SQL database. This was implemented to restore month-end snapshots of a database to a seperate SQL server.
Prevoiusly this was a manual task that would be completed on the first of the month. This task was automated to allow finance additional time to work on reporting.
This script is meant to run as a scheduled task.
#>

Import-Module sqlps
$SQLDataPath = <File Path>
$SQLServerInstance = <Server Instance>
$SQLBackup = <DB Backup path>

$today = Get-Date
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

Start-Transcript -Path C:\scripts\navrestore.log

<# checks if the month of the DB is December, then sets year to previous year #>
if ($month -eq "Dec"){
    $year = $today.Year-1
} else {
    $year = $today.Year
}

<# creates folder for month end DB and renames the NAVLIVE-MonthEnd.bak file to the correct month and year #>
New-Item -Path $SQLDataPath -Name "$($month) $($year)" -ItemType Directory
# Rename-Item -Path "\\dsi-fs03\MonthlyNavBackup\NAVLIVE-MonthEnd.bak" -NewName "$($month) $($year).bak"

<# creates objects for relocating DB data and log files to new folder for month end DB #>
$relocatedata = @(New-Object microsoft.sqlserver.management.smo.relocatefile("NAV-LIVE_Data", "$($SQLDataPath)\$($month) $($year)\NAV-LIVE_Data.mdf"))
$relocatelog = New-Object Microsoft.SqlServer.Management.Smo.RelocateFile("NAV-LIVE_Log","$($SQLDataPath)\$($month) $($year)\NAV-LIVE_Log.ldf")
for ($i=1; $i -lt 9; $i++){
    $relocatedata += (New-Object Microsoft.SqlServer.Management.Smo.RelocateFile("NAV-LIVE_$($i)_Data", "$($SQLDataPath)\$($month) $($year)\NAV-LIVE_$($i)_Data.ndf"))
}

<# Restores DB based and relocates all files to the correct folder for the DB #>
Restore-SqlDatabase -ServerInstance $SQLServerInstance -Database "NAV-LIVE" -BackupFile $SQLBackup -RelocateFile @($relocatedata[0],$relocatedata[1],$relocatedata[2],$relocatedata[3],$relocatedata[4],$relocatedata[5],$relocatedata[6],$relocatedata[7],$relocatedata[8],$relocatelog)
Rename-Item -Path "SQLSERVER:\SQL\<SQL SERVER NAME>\TEST\Databases\NAV-LIVE" -NewName "$($month) $($year)" #renames DB within SQL to correct monthend name

Stop-Transcript