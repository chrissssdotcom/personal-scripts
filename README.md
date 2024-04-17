# Personal Scripts
This is my personal script library. A lot of them will be quite messy, but will do the job just fine.
I'll document them as good as I can, but this isn't my job and a lot of them have been made on the side to aid my job or Homelab.

## PowerShell
`powershell/Run-SetupL2tpVpn.ps1` - This sets up a L2TP vpn using variables provided at the top of the script. Easy enough, was originally used to aid white-glove deployment of workstations.  
`powershell/Run-BulkMailboxDelegation.ps1` - This delegates read and send access to everyone inside the list. Can likely be modified to do the same for Calendars.  
`powershell/Run-BulkMailboxSingleDelegation.ps1` - Runs through $MailboxesList (as a comma seperated list) and assigns a single user Full Access and Send As permissions.  

## Bash
`bash/artemis-backups/backup_script.sh` - Backups my media host's configuration. Also provides a setup script located in `bash/artemis-backups/setup.sh`.
