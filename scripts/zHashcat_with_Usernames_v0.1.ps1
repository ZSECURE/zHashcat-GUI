# =============================================================================
# File Name: zHashcat.ps1
# =============================================================================
# Name: Hashcat Automation Script
# Author: Zak Clifford 
# Contact:  zak@cognisys.co.uk
# Version 1.0
# Created: 8 Mar 2023
# Updated: N/A
# Description: Runs through the wordlists and commands as if you were to do 
# Description: it manually
# =============================================================================
# Function Change Log
# v1.0 - Creation of script
# =============================================================================
$ver = "1.0"

# =============================================================================
# START OF CODE
# =============================================================================

##Start of Script

# Enabling logging for the script and saving to c:\windows\temp
$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | Out-Null
$ErrorActionPreference = "Continue"
Start-Transcript -path C:\windows\temp\zHashcat.txt -append

# Send webhook function
 Function Send-PwdRecoveryUpdate {
    Param (
        [string]$Title,
        [string]$Text
    )
    $JSONBody = [PSCustomObject][Ordered]@{
"@type" = "MessageCard"
"@context" = "<http://schema.org/extensions>"
"summary" = "Job Complete, Check The Kraken!"
"themeColor" = '0078D7'
"title" = $Title
"text" = $Text
}

$TeamMessageBody = ConvertTo-Json $JSONBody

$parameters = @{
"URI" = ''
"Method" = 'POST'
"Body" = $TeamMessageBody
"ContentType" = 'application/json'
}

Invoke-RestMethod @parameters 

} 

Function Show-zHashcatUsage {
    
    #Define usage message
    Write-Host "`n Usage: zHashcat.ps1 <mode> <hashFilename> <client>" -ForegroundColor Yellow
    Write-Host "`n  This is with the --username flag and runs all wordlists:" -ForegroundColor Yellow
    foreach($rule in "best64.rule", "InsidePro-PasswordsPro.rule", "OneRuleToRuleThemAll.rule", "OneRuleToRuleThemStill.rule", "dive.rule", "d3ad0ne.rule", "Incisive-leetspeak.rule", "InsidePro-HashManager.rule", "leetspeak.rule", "rockyou-30000.rule", "T0XlC.rule", "T0XlC_3_rule.rule", "T0XlC_insert_HTML_entities_0_Z.rule", "T0XlC-insert_00-99_1950-2050_toprules_0_F.rule", "T0XlC-insert_space_and_special_0_F.rule", "T0XlC-insert_top_100_passwords_1_G.rule", "T0XlCv2.rule", "toggles1.rule", "toggles2.rule", "toggles3.rule", "toggles4.rule", "toggles5.rule", "unix-ninja-leetspeak.rule"){
    Write-Host "     - $rule" -ForegroundColor Magenta
    }
}

#Check if two parameters are passed
if ($args.Count -ne 3 ) {
    #Exit and show usage message
    #Invoke the function
    Show-zHashcatUsage
    exit
}

# Setting the variable
$hashMode=$args[0]
$hashFilename=$args[1]
$client=$args[2]
$rules="best64.rule", "InsidePro-PasswordsPro.rule", "OneRuleToRuleThemAll.rule", "OneRuleToRuleThemStill.rule", "dive.rule", "d3ad0ne.rule", "Incisive-leetspeak.rule", "InsidePro-HashManager.rule", "leetspeak.rule", "rockyou-30000.rule", "T0XlC.rule", "T0XlC_3_rule.rule", "T0XlC_insert_HTML_entities_0_Z.rule", "T0XlC-insert_00-99_1950-2050_toprules_0_F.rule", "T0XlC-insert_space_and_special_0_F.rule", "T0XlC-insert_top_100_passwords_1_G.rule", "T0XlCv2.rule", "toggles1.rule", "toggles2.rule", "toggles3.rule", "toggles4.rule", "toggles5.rule", "unix-ninja-leetspeak.rule"
$rulesBig="best64.rule", "InsidePro-PasswordsPro.rule", "OneRuleToRuleThemStill.rule"

Write-Host You have selected this location for the hashfile: $hashFilename
Write-Host You have selected this as the client name: $client

# Ensure you are in the right directory
cd c:\hashcat-6.2.6\

# Logging the start time of the script
(get-date).ToString('T')

# Using all Public-Wordlists
C:\hashcat-6.2.6\hashcat.exe --quiet --username -m $hashMode -w4 -O $hashFilename D:\Wordlists\Public-Wordlists\*
$UpdateOne=(C:\hashcat-6.2.6\hashcat.exe --username -m $hashMode -w4 -O $hashFilename D:\Wordlists\Status.txt)  | Select-String "Recovered" 
$Update1=$UpdateOne -replace 'Digests(.*)', '' 

Send-PwdRecoveryUpdate -Title "Hashcat Update for Client: $client" -Text  "Stage 1 - All the public wordlists have been tried, this is the results so far: $Update1" 


# Using RockYou
$rockYou="D:\Wordlists\Public-Wordlists\C-rockyou.txt"
Write-Host Now using the wordlist $rockYou
foreach($rule in $rules){
    C:\hashcat-6.2.6\hashcat.exe --username -m $hashMode -w4 -O $hashFilename $rockYou -r .\rules\$rule --quiet
}
$UpdateTwo=(C:\hashcat-6.2.6\hashcat.exe --username -m $hashMode -w4 -O $hashFilename D:\Wordlists\Status.txt)  | Select-String "Recovered" 
$Update2=$UpdateTwo -replace 'Digests(.*)', '' 
Send-PwdRecoveryUpdate -Title "Hashcat Update for Client: $client" -Text  "Stage 2 - Rockyou and all the rule sets have been tried, this is the results so far: $Update2" 

# Using Kaonashi.txt
$kaonashi="D:\Wordlists\Public-Wordlists\D-kaonashi.txt"
Write-Host Now using the wordlist $rockTastic
foreach($rule in $rules){
    C:\hashcat-6.2.6\hashcat.exe --username -m $hashMode -w4 -O $hashFilename $kaonashi -r .\rules\$rule --quiet
}
$UpdateThree=(C:\hashcat-6.2.6\hashcat.exe --username -m $hashMode -w4 -O $hashFilename D:\Wordlists\Status.txt)  | Select-String "Recovered" 
$Update3=$UpdateThree -replace 'Digests(.*)', '' 
Send-PwdRecoveryUpdate -Title "Hashcat Update for Client: $client" -Text  "Stage 3 - Kaonashi.txt and all the rule sets have been tried, this is the results so far: $Update3"


# Using Rocktastic12a
$rockTastic="D:\Wordlists\Public-Wordlists\E-rocktastic12a.txt"
Write-Host Now using the wordlist $rockTastic
foreach($rule in $rules){
    C:\hashcat-6.2.6\hashcat.exe --username -m $hashMode -w4 -O $hashFilename $rockTastic -r .\rules\$rule --quiet
}
$UpdateThree=(C:\hashcat-6.2.6\hashcat.exe --username -m $hashMode -w4 -O $hashFilename D:\Wordlists\Status.txt)  | Select-String "Recovered" 
$Update3=$UpdateThree -replace 'Digests(.*)', '' 
Send-PwdRecoveryUpdate -Title "Hashcat Update for Client: $client" -Text  "Stage 4 - Rocktastic and all the rule sets have been tried, this is the results so far: $Update3"

# Using realuniq
$realUniq="D:\Wordlists\Public-Wordlists\F-realuniq.lst"
Write-Host Now using the wordlist $realUniq
foreach($rule in $rules){
    C:\hashcat-6.2.6\hashcat.exe --username -m $hashMode -w4 -O $hashFilename $realUniq -r .\rules\$rule --quiet
}
$UpdateFour=(C:\hashcat-6.2.6\hashcat.exe --username -m $hashMode -w4 -O $hashFilename D:\Wordlists\Status.txt)  | Select-String "Recovered" 
$Update4=$UpdateFour -replace 'Digests(.*)', '' 
Send-PwdRecoveryUpdate -Title "Hashcat Update for Client: $client" -Text  "Stage 5 - Realuniq and all the rule sets have been tried, this is the results so far: $Update4"


# Using b0n3z
$b0n3z="D:\Wordlists\Public-Wordlists\G-b0n3z-sorted-wordlist"
Write-Host Now using the wordlist $b0n3z
foreach($rule in $rulesBig){
    C:\hashcat-6.2.6\hashcat.exe --username -m $hashMode -w4 -O $hashFilename $b0n3z -r .\rules\$rule --quiet
}
$UpdateFive=(C:\hashcat-6.2.6\hashcat.exe --username -m $hashMode -w4 -O $hashFilename D:\Wordlists\Status.txt)  | Select-String "Recovered" 
$Update5=$UpdateFive -replace 'Digests(.*)', '' 
Send-PwdRecoveryUpdate -Title "Hashcat Update for Client: $client" -Text  "Stage 6 - b0n3z and all 3 rule sets have been tried, this is the results so far: $Update5"


# Using weakpass_3a
$weakPass3a="D:\Wordlists\Public-Wordlists\I-weakpass_3a.txt"
Write-Host Now using the wordlist $weakPass3a
foreach($rule in $rulesBig){
    C:\hashcat-6.2.6\hashcat.exe --username -m $hashMode -w4 -O $hashFilename $weakPass3a -r .\rules\$rule --quiet
}
$UpdateSix=(C:\hashcat-6.2.6\hashcat.exe --username -m $hashMode -w4 -O $hashFilename D:\Wordlists\Status.txt)  | Select-String "Recovered" 
$Update6=$UpdateSix -replace 'Digests(.*)', '' 
Send-PwdRecoveryUpdate -Title "Hashcat Update for Client: $client" -Text  "Stage 7 - Weakpass_3a and all 3 rule sets have been tried, this is the results so far: $Update6"


# Logging the end time
(get-date).ToString('T')

# Cracking Completed sending web hook
$UpdateFinal=(C:\hashcat-6.2.6\hashcat.exe --username -m $hashMode -w4 -O $hashFilename D:\Wordlists\Status.txt)  | Select-String "Recovered" 
$UpdateF=$UpdateFinal -replace 'Digests(.*)', '' 
Send-PwdRecoveryUpdate -Title "Hashcat Update for Client: $client" -Text  "Completed - The password recovery has finished, these are the results: $UpdateF"

Write-Host Completed - The password recovery has finished, these are the results: $UpdateF

Stop-Transcript 