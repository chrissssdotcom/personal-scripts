# Import the Exchange Online module
Import-Module ExchangeOnlineManagement

# Connect to Exchange Online (you may need to install the ExchangeOnlineManagement module if you haven't already)
Connect-ExchangeOnline -ShowProgress $true

# Define the list of mailboxes to grant permissions from
$MailboxesList = @("listofusers@contoso.com","otheruser@contoso.com")

# Define the user to grant permissions to
$UserToGrantPermissions = "singleuser@contoso.com"

# Loop through the list of mailboxes and grant "Send As" and "Read" permissions to the user
foreach ($Mailbox in $MailboxesList) {
    Write-Output "Granting 'Send As' and 'Read' permissions from $Mailbox to $UserToGrantPermissions"
    
    # Grant "Send As" permission
    Add-RecipientPermission -Identity $Mailbox -Trustee $UserToGrantPermissions -AccessRights "SendAs"

    # Grant "Read" permission
    Add-MailboxPermission -Identity $Mailbox -User $UserToGrantPermissions -AccessRights "FullAccess"
}

# Disconnect from Exchange Online session
Disconnect-ExchangeOnline -Confirm:$false
