# this was used in conjunction with WindowsUpdate.ps1 to determine when the last updates were installed on each server and domain controller.
#Author: Alex Nash

$serverou = Read-Host -Prompt "enter the DN of the OU where the servers reside:"
$servers = Get-ADComputer -SearchBase $serverou 
$dcs = Get-ADComputer -SearchBase "OU=domain controllers,DC=<Domain>,DC=com"

foreach ($server in $servers){

    get-hotfix -ComputerName $server.name | Sort-Object InstalledOn -Descending| select -First 1| Export-Csv '.\LastUpdate.cvs' -Append
    
}
foreach ($dc in $dcs){

    get-hotfix -ComputerName $dc.name | Sort-Object InstalledOn -Descending| select -First 1| Export-Csv '.\LastUpdate.csv' -Append

}