# maintain Servers security group in AD. 
# Author: Alex Nash

$serversOU = Read-Host 'Enter the DN of the OU containing all servers:'
$DCOU = Read-Host 'Enter the DN of the Domain Controllers OU:'

$servers = get-adcomputer -searchbase $serversOU -Filter {(enabled -eq $true) -and (name -ne "Reprodesk")} # Reprodesk was a computer in the servers OU that was not expected to be a member of this group.
$servers += get-adcomputer -searchbase $DCOU -Filter {enabled -eq $true}

# adds servers to Servers AD Group
Add-ADGroupMember -Identity "Servers" -Members $servers

# removes disabled (i.e. decommissioned or left domain) servers from Servers AD Group
$members = Get-ADGroupMember -Identity "servers"
foreach($member in $members){
    if((get-adcomputer $member.name).enabled -eq $false){
        Remove-ADGroupMember -Identity "servers" -Members $member
    }
}