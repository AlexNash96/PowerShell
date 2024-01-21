#Script to remove disabled users from distribution groups
#This was run as a scheduled task to ensure users would not get NDRs after an employee left the company.
#Author: Alex Nash
Start-transcript -Path ".\DistCleanup.log"

$groups = get-adgroup -Filter {groupcategory -eq "Distribution"}    # finds all Distribution groups in domain

<# loop to run through each distribution group found above #>
foreach($group in $groups){
    $users = Get-ADGroupMember -Identity $group # gets list of group members

    <# loop to run through each user found above #>
    foreach($user in $users){
        $ad = get-aduser -Identity $user.samaccountname # gets aduser properties for later

        <# checkes if user is disabled and removes them from the distribution group if they are disabled #>
        if($ad.enabled -eq $false){
            Remove-ADGroupMember -Identity $group.name -Members $ad.samaccountname -confirm:$false


        }
    }
}

Stop-Transcript