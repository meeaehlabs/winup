@echo off
# This expects the script file to be in the temp folder 

PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Windows\Temp\uptime.ps1"

# Use this file to trigger the script to run if you are using remote commands i.e. Jumpcloud 
# This makes sure the script can run in an interactive mode to support dialogue boxes


# Use this option to trigger the script if you want it controlled remotely from your device management of choice 

