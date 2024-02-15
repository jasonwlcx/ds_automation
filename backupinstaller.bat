@echo off

rem DS_Automation Installer

rem Installs ds_automation into users documents folder
curl -Uri "https://github.com/jasonwlcx/ds_automation/releases/download/alpha/ds_automation.exe" -Outfile "%USERPROFILE%\Downloads\ds_automation.exe"
curl -Uri "https://raw.githubusercontent.com/jasonwlcx/ds_automation/main/ds_automation.xml" -Outfile "%USERPROFILE%\Downloads\ds_automation.xml"

set "pathToFolder=%USERPROFILE%\Documents\ds_automation"
if exist "%pathToFolder%" (
    echo Folder already exists.
) else (
    echo Creating folder to store ds_automation
    mkdir "%USERPROFILE%\Documents\ds_automation"
)

move /Y "%USERPROFILE%\Downloads\ds_automation.exe" "%USERPROFILE%\Documents\ds_automation\ds_automation.exe"
move /Y "%USERPROFILE%\Downloads\ds_automation.xml" "%USERPROFILE%\Documents\ds_automation\ds_automation.xml"

rem edit xml file
set "xmlFile=%USERPROFILE%\Documents\ds_automation\ds_automation.xml"
set "exePath=%USERPROFILE%\Documents\ds_automation\ds_automation.exe"

rem Read the existing xml file
powershell -Command "$xmlDoc = [xml](Get-Content '%xmlFile%'); $xmlDoc.task.actions.exec.command = '%exePath%'; $xmlDoc.Save('%xmlFile%')"

rem Prompt the user for password
set /p Password="Please enter user password: "

rem Schedule the task
schtasks /Create /XML "%USERPROFILE%\Documents\ds_automation\ds_automation.xml" /TN "ds_automation" /RU "%USERDOMAIN%\%USERNAME%" /RP %Password% /F
