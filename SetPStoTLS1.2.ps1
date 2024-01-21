# Wrote this simply to update servers to use the new TLS 1.2 requirement when installing powershell modules from PS Gallery
# Author: Alex Nash

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 
Install-Module PowerShellGet -RequiredVersion 2.2.4 -SkipPublisherCheck