# DS_Automation Installer
# @Author: Brayden Graham
# @echo off

# Installs ds_automation into users documents folder
Invoke-WebRequest -Uri "https://github.com/jasonwlcx/ds_automation/releases/download/alpha/ds_automation.exe" -Outfile $env:USERPROFILE\Downloads\ds_automation.exe
mkdir $env:USERPROFILE\Documents\ds_automation
Move-Item -Path $env:USERPROFILE\Downloads\ds_automation.exe -Destination $env:USERPROFILE\Documents\ds_automation\ds_automation.exe

# Prompt user for password and setup scheduled task
$Password = Read-Host "Please enter user password: "
Register-ScheduledTask -Xml (get-content 'C:\Users\jwilcox\OneDrive - Cricut\Desktop\ds_automation.xml' | out-string) -TaskName "ds_automation" -User $env:USERDOMAIN\$env:USERNAME -Password $Password -Force
