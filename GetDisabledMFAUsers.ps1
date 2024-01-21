#checks for uesrs in the specified domain that have MFA disabled throught the M365 admin center.
#This does not check if MFA is enforced in Azure
#Author: Alex Nash

$domain = Read-Host -Prompt 'Enter the domain you would like to filter on:'
Connect-MsolService
get-msoluser -DomainName $domain| select displayname,@{N="MFAStatus";E={if($_.strongauthenticationrequirements.count -ne 0){$_.strongauthenticationrequirements[0].state}else{'disabled'}}}|Sort-Object -Property displayname|where{$_.MFASTATUS -eq 'disabled'}
pause