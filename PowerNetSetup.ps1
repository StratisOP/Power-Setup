#Enable firewall rule for Remote Desktop - User Mode (TCP & UDP)
Get-NetFirewallRule -DisplayName "Remote Desktop - User*" | Set-NetFirewallRule -Enabled true
#Enable firewall rule for Remote Desktop - User Mode (TCP & UDP)
Get-NetFirewallRule -DisplayName "Απομακρυσμένη επιφάνεια εργασίας - Λειτουργία χρήστη*" | Set-NetFirewallRule -Enabled true
#Disable Automatically Detect proxy settings
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" AutoDetect 0