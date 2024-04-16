# Import the Exchange Online module
Import-Module ExchangeOnlineManagement

# Connect to Exchange Online (you may need to install the ExchangeOnlineManagement module if you haven't already)
Connect-ExchangeOnline -UserPrincipalName exoadmin@contoso.com -ShowProgress $true

# Define the list of mailboxes to delegate access from and to
$MailboxesList = @("commaseperatedidentities@google.com","meow@contoso.com")

# Loop through the list and delegate full access and "Send As" permissions
foreach ($Mailbox in $MailboxesList) {
    Write-Output "Delegating full access and 'Send As' permissions for $Mailbox"

    # Get all mailboxes except the current one in the loop
    $OtherMailboxes = $MailboxesList | Where-Object { $_ -ne $Mailbox }

    # Delegate full access to the current mailbox from other mailboxes
    foreach ($OtherMailbox in $OtherMailboxes) {
        Add-MailboxPermission -Identity $Mailbox -User $OtherMailbox -AccessRights "FullAccess"
    }

    # Delegate "Send As" permissions to the current mailbox from other mailboxes
    foreach ($OtherMailbox in $OtherMailboxes) {
        Add-RecipientPermission -Identity $Mailbox -Trustee $OtherMailbox -AccessRights "SendAs"
    }
}

# Disconnect from Exchange Online session
Disconnect-ExchangeOnline -Confirm:$false
