<#
This script is written to create a published Citrix app that is a copy of a month end SQL database for Dynamics Nav.
This script is meant to run as a scheduled task
Author: Alex Nash
#>

Start-transcript -Path C:\Scripts\CreateMonthEndApp.log
Add-PSSnapin citrix*

$SQLServer = "<SQL SERVER>"
$Company = "<NAV Company>"
$AppGroup = "<App Group name>"
$UserGroup = "<User Group name"
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

<# checks if the month of the DB is December, then sets year to previous year #>
if ($month -eq "Dec"){
    $year = $today.Year-1
} else {
    $year = $today.Year
}

New-BrokerApplication -ApplicationType HostedOnDesktop -Name "$($month) $($year)" -CommandLineExecutable "C:\Program Files (x86)\Microsoft Dynamics NAV\60\Classic\finsql.exe" -CommandLineArguments "servername=$($SQLServer),database=$($month) $($year),company=`"$($Company)`",ID=standalone,objectcache=64000" -DesktopGroup $AppGroup -UserFilterEnabled $true -IconUid 4
Add-BrokerUser $UserGroup -Application "$($month) $($year)"
Stop-Transcript