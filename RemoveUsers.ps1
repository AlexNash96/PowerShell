#This script will remove AzureAD users when their UPN matches the domain in question
# Author: Alex Nash

$domain = Read-Host -Prompt "Please enter the UPN Suffix:"
Remove-AzureADUser -ObjectID (Get-AzureADUser -All $true | Where-Object {$_.UserPrincipalName -like "*@$($domain)"}).ObjectID