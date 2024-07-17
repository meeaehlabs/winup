@echo off
setlocal

powershell.exe -Command "Set-ExecutionPolicy Bypass -Scope Process -Force"

mkdir C:\Uptime

copy C:\Windows\Temp\uptime.ps1 C:\Uptime\

schtasks /create /tn "RunUptimeScriptMorning" /tr "powershell.exe -ExecutionPolicy Bypass -File C:\Uptime\uptime.ps1" /sc daily /st 09:00 /ru System
schtasks /create /tn "RunUptimeScriptEvening" /tr "powershell.exe -ExecutionPolicy Bypass -File C:\Uptime\uptime.ps1" /sc daily /st 21:00 /ru System

echo. > C:\Windows\Temp\uptimelog.txt

echo Batch script executed successfully.
