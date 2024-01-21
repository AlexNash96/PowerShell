<#
This script will get names of folders and file counts in a synced sharepoint folder.
This was used to split up the migration from one SharePoint folder to another with large file counts
Author: Alex Nash
#>


<#!!! CHANGE TO CORRECT PATH FOR SHAREPOINT FOLDER !!!#>
Set-Location "<SYNCED SHAREPOINT FOLDER DIRECTORY>"
$table = @()
$folders = Get-ChildItem
foreach($folder in $folders){
    $result = "" |select Name,Count
    $result.name = $folder.name
    $result.count = (get-childitem $folder.name -recurse).count + 1
    $table += $result
}

<#!!!  CHANGE "Output.csv" TO MEANINGFUL NAME  !!!#>
$table |export-csv -Path ".\TeamsFolderInfo.csv" -NoTypeInformation