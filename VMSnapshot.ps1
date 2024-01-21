<#
This script runs as a scheduled task to maintain a single recent snapshot for VMs hosted on Hyper-V.
To add protection to the snapshots, it also copies the snapshot to a separate location to be stored
Author: Alex Nash
#>

$vms = get-vm
$SnapshotStore = Read-Host "please provide the path to the snapshot storage:"
foreach($vm in $vms){
    $dir = "$($SnapshotStore)\$($vm.name)"
    if(Test-Path -Path $dir){                            #Checks for pre-existing backup
        Remove-Item $dir -recurse                            #deletes pre-existing backup
        Get-VM -Name $VM.name | Remove-VMSnapshot -Name Backup    #deletes old checkpoint
    }
    Save-VM -Name $VM.name                                                          #shutsdown VM
    Get-VM -Name $VM.name | Checkpoint-VM -SnapshotName Backup                      #creates new checkpoint to be backed up
    Export-VMSnapshot -Name 'Backup' -VMName $VM.name -Path $SnapshotStore          #Exports the checkpoint to file share to act as backup for VM
    Get-VM -Name $VM.name | Start-VM                                                #Restarts the VM
}