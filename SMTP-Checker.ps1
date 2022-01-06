<#
.SYNOPSIS
SMTP-CHECKER.ps1

.DESCRIPTION 
A description of this script.

.EXAMPLE
.\SMTP-CHECKER.ps1

.LINK
https://

.NOTES
Written by: Rafael López

Find me on:

* LinkedIn:	https://linkedin.com/in//
* Github:	https://github.com/Raffa182/Exchange

Change Log:
V1.00, 12/01/2021 - Initial version
#>

#region Variables
$filename=get-date -Format 'yyyy-MM-dd-hh-mm'
$counter=0
$max=4000
#endregion variables

Start-Transcript .\"$filename"_LOG.txt

# Collect mailboxes

$fix = Import-csv "Folder & File"

$mbx = $fix | Foreach-Object {Get-recipient -ResultSize Unlimited -identity $_.SamAccountName}

# Loop section
foreach ($target in $mbx) {
    IF ($target.emailaddresses -like "*@bluecrossmn.com") {
    Write-host $target.Name "Email OK" -ForegroundColor Green
    }
    ELSE {
    $counter++
    IF ($counter -lt $max) {
    Write-Host "*@bluecrossmn.com does not exist on" $target -ForegroundColor Yellow
    Write-Host "Processing object number" $counter -ForegroundColor Yellow
    Get-Mailbox -Identity $target.Alias | select @{Name='EmailAddress';Expression={$_.PrimarySMTPAddress}} | Export-Csv -NoTypeInformation -Delimiter ";" .\"$filename"_Added_onmicrosft_address.csv -Append
                    $sUserToAdjust = $target.PrimarySmtpAddress
                    $sPrimarySmtpAddress = Get-Mailbox $sUserToAdjust | select -ExpandProperty PrimarySmtpAddress
                    $sOnMicrosoftSmtpAddress = ($sPrimarySmtpAddress).split("@") | Select-Object -Index 0
                    $sOnMicrosoftSmtpAddress = $sOnMicrosoftSmtpAddress+"@bluecrossmn.com"

                    Set-Mailbox -Identity $sUserToAdjust -EmailAddresses @{add="smtp:$sOnMicrosoftSmtpAddress"}
                            }
                            ELSE {
                            Write-Host "Max mailboxes reached" -ForegroundColor Red
                            Stop-Transcript
                            EXIT
                                                        }
}
}
