# Define VPN connection parameters
$serverAddress = ""
$preSharedKey = ""
$siteName = ""

# VPN connection with split tunneling enabled
$vpnName1 = "Client - "$siteName " - (Split Tunnelling)"
Add-VpnConnection -Name $vpnName1 -ServerAddress $serverAddress -TunnelType "L2tp" -L2tpPsk $preSharedKey -Force -RememberCredential
Set-VpnConnection -Name $vpnName1 -SplitTunneling $true -AuthenticationMethod MSChapv2 -EncryptionLevel Maximum
Write-Output "VPN connection $vpnName1 with split tunneling enabled has been successfully set up."

# VPN connection with split tunneling disabled
$vpnName2 = "Client - "$siteName " - (Full Tunnelling)"
Add-VpnConnection -Name $vpnName2 -ServerAddress $serverAddress -TunnelType "L2tp" -L2tpPsk $preSharedKey -Force -RememberCredential
Set-VpnConnection -Name $vpnName2 -SplitTunneling $false -AuthenticationMethod MSChapv2 -EncryptionLevel Maximum
Write-Output "VPN connection $vpnName2 with split tunneling disabled has been successfully set up."

# Add AssumeUDPEncapsulationContextOnSendRule registry value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\PolicyAgent"
$regName = "AssumeUDPEncapsulationContextOnSendRule"
$regValue = 2

New-ItemProperty -Path $regPath -Name $regName -Value $regValue -PropertyType DWORD -Force

Write-Output "Added $regName registry value with value $regValue."

# Prompt to reboot
Write-Output "Please reboot your system to apply the changes."
$confirmReboot = Read-Host "Would you like to reboot now? (Y/N)"

if ($confirmReboot -eq "Y" -or $confirmReboot -eq "y") {
    Restart-Computer -Force
} else {
    Write-Output "You chose not to reboot. Please manually reboot your system later to apply the changes."
}
