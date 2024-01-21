<#********************************************************************************************
    This script was used to ensure AD distribution groups were always up to date.
    In this domain, each distribution group had a corresponding security group. In some
    cases, the users in the security group were not immediately added to the distribution
    group, so I wrote this script to ensure the DGs were always up to date with the SGs.

    Author: Alex Nash
********************************************************************************************#>

Start-Transcript -Path ".\Output\AddDistributionGroupMembers.log" # starts logging

<# Gets all enabled users in AD in Specified OU (set up for dsiamerica to ignore non-synced OUs) #>

$OU = Read-Host -Prompt 'Enter the DN of the OU you where users are located'
$users = Get-aduser -SearchBase $OU -filter {enabled -eq $true} -Properties mail

<# list of Distribtuion groups and corresponding Security groups
   correspodning groups must be in the same position in the list
   (i.e. $sgs[3] corresponds to $dgs[3])                        
   $dgs is for distribution groups and $sgs is for security Groups 
#>

$dgs = "mail1","mail2","mail3" # list of Distribution groups here
$sgs = "group1","group2","group3" # list of corresponding Security groups here
$AllUserDG = Get-ADGroupMember -Identity "AllUserDG" # gets members of all users DG

<# Loop will add users to the AllUserDG distribution group
   if they are not already a member of the group and they are mail 
   enabled. AllUserDG is a distribution group for all users in
   the domain.
#>

foreach($user in $users){
if(($AllUserDG -notcontains $user.samaccountname) -and ($user.mail)) {Add-ADGroupMember -Identity "AllUserDG" -Members $user.samaccountname} # adds user to distribution group for all users if not already a member
}

<# Loop will iterate over the length of the $dgs array and 
   this loop will get group members from the security groups one
   at a time. Next, it will loop through all the users found in the
   security group and add any users to the distribution groups that are 
   mail-enbaled, members of the corresponding security group, 
   and not currently a member of the distribution group
#> 

for(($i=0);($i -lt $dgs.count);$i++){  # iterates $i in each loop until it reaches the length of the $dgs array
    $dgmembers = Get-ADGroupMember -Identity $dgs[$i]|select -ExpandProperty samaccountname # gets samaccountname of users in $dgs[$i]
    $sgmembers = Get-ADGroupMember -Identity $sgs[$i]|select -ExpandProperty samaccountname # gets samaccountname of users in $sgs[$i]
        foreach($member in $sgmembers){
            $user = get-aduser $member -Properties mail  # gets aduser properites for $user.mail to be user later
            if(($sgmembers -contains $member) -and ($user.mail) -and ($dgmembers -notcontains $member) -and ($user.enabled)){  # checks if user is member of sg, mail enabled, and not member of dg
                Add-ADGroupMember -Identity  $dgs[$i] -Members $member -Confirm:$false  # adds user to dg
            }
        }
}

Stop-Transcript