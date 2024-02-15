# DS_Automation Installer

# Installs ds_automation into users documents folder
Invoke-WebRequest -Uri "https://github.com/jasonwlcx/ds_automation/releases/download/alpha/ds_automation.exe" -Outfile $env:USERPROFILE\Downloads\ds_automation.exe
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/jasonwlcx/ds_automation/main/ds_automation.xml" -Outfile $env:USERPROFILE\Downloads\ds_automation.xml

$pathToFolder = $env:USERPROFILE+"\Documents\ds_automation"
if (Test-Path $pathToFolder) {
    Write-Host "Folder already exits."
} else {
    Write-Host "Creating folder to store ds_automation"
    mkdir $env:USERPROFILE\Documents\ds_automation
}

Move-Item -Path $env:USERPROFILE\Downloads\ds_automation.exe -Destination $env:USERPROFILE\Documents\ds_automation\ds_automation.exe -Force
Move-Item -Path $env:USERPROFILE\Downloads\ds_automation.xml -Destination $env:USERPROFILE\Documents\ds_automation\ds_automation.xml -Force

# Read the existing xml file
[xml]$xmlDoc = Get-Content $env:USERPROFILE\Documents\ds_automation\ds_automation.xml
$xmlDoc.task.actions.exec.command = $env:USERPROFILE+"\Documents\ds_automation\ds_automation.exe"
# Save back to the xml file
$xmlDoc.Save("$env:USERPROFILE\Documents\ds_automation\ds_automation.xml")

# Prompt the user for password
$Password = Read-Host "Please enter user password"

# 'System.Security.SecureString'
#$Password = ConvertFrom-SecureString -SecureString $sPassword

# Schedule the task
Register-ScheduledTask -Xml (get-content "$env:USERPROFILE\Documents\ds_automation\ds_automation.xml" | out-string) -TaskName "ds_automation" -User $env:USERDOMAIN\$env:USERNAME -Password $Password -Force
