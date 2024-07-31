@echo off
setlocal

# Since this script is expecting to have scheduled run times it will make a folder in the C drive to store the script in a permanent place for the system-scheduled tasks to ensure the script isn't lost when temp files are cleared 
#Run this as an Admin

powershell.exe -Command "Set-ExecutionPolicy Bypass -Scope Process -Force"

mkdir C:\Uptime

copy C:\Windows\Temp\uptime.ps1 C:\Uptime\

# Creates System Task to run the script at 9 AM and 9 PM 
schtasks /create /tn "RunUptimeScriptMorning" /tr "powershell.exe -ExecutionPolicy Bypass -File C:\Uptime\uptime.ps1" /sc daily /st 09:00 /ru System
schtasks /create /tn "RunUptimeScriptEvening" /tr "powershell.exe -ExecutionPolicy Bypass -File C:\Uptime\uptime.ps1" /sc daily /st 21:00 /ru System

echo. > C:\Windows\Temp\uptimelog.txt

echo Batch script executed successfully.
