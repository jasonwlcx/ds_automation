import os
import requests
import shutil
import xml.etree.ElementTree as ET
from getpass import getpass
import subprocess

# Define GitHub repository details
repo_owner = "jasonwlcx"
repo_name = "ds_automation"

# Define file paths
downloads_folder = os.path.join(os.path.expanduser("~"), "Downloads")
ds_automation_folder = os.path.join(os.path.expanduser("~"), "Documents", "ds_automation")
exe_destination = os.path.join(ds_automation_folder, "ds_automation.exe")
xml_destination = os.path.join(ds_automation_folder, "ds_automation.xml")

# Get the latest release information from GitHub API
release_url = f"https://api.github.com/repos/{repo_owner}/{repo_name}/releases/latest"
response = requests.get(release_url)
latest_release = response.json()

# Extract download URLs from the release information
exe_url = next(asset["browser_download_url"] for asset in latest_release["assets"] if asset["name"] == "ds_automation.exe")
xml_url = next('https://raw.githubusercontent.com/jasonwlcx/ds_automation/main/ds_automation.xml')

# Install ds_automation into the user's documents folder
exe_response = requests.get(exe_url)
xml_response = requests.get(xml_url)

with open(os.path.join(downloads_folder, "ds_automation.exe"), "wb") as exe_file:
    exe_file.write(exe_response.content)

with open(os.path.join(downloads_folder, "ds_automation.xml"), "wb") as xml_file:
    xml_file.write(xml_response.content)

# Create folder if it doesn't exist
if not os.path.exists(ds_automation_folder):
    print("Creating folder to store ds_automation")
    os.makedirs(ds_automation_folder)

# Move files to destination
shutil.move(os.path.join(downloads_folder, "ds_automation.exe"), exe_destination)
shutil.move(os.path.join(downloads_folder, "ds_automation.xml"), xml_destination)

# Read the existing xml file and update the command
tree = ET.parse(xml_destination)
root = tree.getroot()
root.find(".//exec/command").text = exe_destination
tree.write(xml_destination)

# Prompt the user for a secure password
password = getpass("Please enter user password: ")

# Schedule the task using schtasks
command = (
    f'schtasks /Create /XML "{xml_destination}" /TN "ds_automation" '
    f'/RU {os.environ["USERDOMAIN"]}\{os.environ["USERNAME"]} /RP {password} /F'
)
subprocess.run(command, shell=True)

print("DS_Automation installation and task scheduling completed.")
