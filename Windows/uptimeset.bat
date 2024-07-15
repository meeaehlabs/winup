@echo off
setlocal

powershell.exe -Command "Set-ExecutionPolicy Bypass -Scope Process -Force"

mkdir C:\Uptime
copy C:\Windows\Temp\uptime.ps1 C:\Uptime\

powershell.exe -Command "schtasks /create /tn 'RunUptimeScript' /tr 'powershell.exe -ExecutionPolicy Bypass -File C:\Uptime\uptime.ps1' /sc onevent /ec System /mo ' '*[System[Provider[@Name='Microsoft-Windows-Security-Auditing'] and (EventID=4801)]]' /ru System"

echo. > C:\Windows\Temp\uptimelog.txt

echo Batch script executed successfully.

pause
