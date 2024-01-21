# Runs targeted powershell script as administrator
# author: Alex Nash
$ScriptPath = Read-Host -Prompt "Enter the path to script to be elevated:"
start-process powershell -verb runas -argument $ScriptPath