#Param([Parameter(Mandatory=$True)]
#   [String]
#       $OU)
[System.Collections.ArrayList]$Result = @()
$Mailboxes = Import-Csv D:\Raffa\ExO_P0_Prep.csv
$Output = "D:\Raffa\Exo_P0_Report.csv"
$count = 0
$filename= Get-Date -Format 'yyyy-MM-dd-hh-mm'
Start-Transcript .\"$filename"_LOG.txt

foreach ($Sam in $Mailboxes) {

    $count++

    Write-Host "Working on user $($Sam.Name) number $count/$($Mailboxes.count)"

    # Get information from Mailboxes -> $Mailboxes (Get-Mailbox)

    $Name = $Sam.Name
    $Email = $Sam.PrimarySmtpAddress
    $SamAccountName = $Sam.SamAccountName
    $OrganizationalUnit = $Sam.OrganizationalUnit

    switch (($Sam.OrganizationalUnit -split ("/"))[0])
	 
    {
    "am.boehringer.com" {$server = "INGDCAM01.am.boehringer.com"}
    "eu.boehringer.com" {$server = "INHDC01.eu.boehringer.com"}
    "ap.boehringer.com" {$server = "INGDCAP01.ap.boehringer.com"}
    "boehringer.com" {$server = "INGRC01.boehringer.com"}
    }
	

    $Enabled = (Get-ADUser $SamAccountName -Properties enabled -Server $server).enabled
    $TrueAD = $Enabled | Select-String -Pattern "True"

    if ($TrueAD -eq $Null){
        $IsActive = "No"
        }
    else{
        $IsActive = "Yes"
        }
     
    $Obj = new-object PSObject
    $Obj | add-member -membertype NoteProperty -name "Name" -value $Name
    $Obj | add-member -membertype NoteProperty -name "Email" -value $Email
    $Obj | add-member -membertype NoteProperty -name "SamAccountName" -value $SamAccountName
    $Obj | add-member -membertype NoteProperty -name "IsActive" -value $IsActive
        
    $Result += $Obj
} 

$Result | export-csv $Output -NoTypeInformation -Encoding UTF8

Stop-Transcript