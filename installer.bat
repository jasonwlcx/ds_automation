:: DS_Automation Installer
:: @Author: Brayden Graham
@echo off

:: Installs ds_autmation into users documents folder
curl -L --url "https://github.com/jasonwlcx/ds_automation/releases/download/alpha_v0.1/ds_automation.exe" --output %USERPROFILE%\Downloads\ds_automation.exe
mkdir %USERPROFILE%\Documents\ds_automation
move %USERPROFILE%\Downloads\ds_automation.exe %USERPROFILE%\Documents\ds_automation\ds_automation.exe

:: nextsteps(placeholder name)
