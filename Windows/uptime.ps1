# Function to get system uptime in days
function Get-UptimeDays {
    $os = Get-WmiObject -Class Win32_OperatingSystem
    $uptime = (Get-Date) - [System.Management.ManagementDateTimeConverter]::ToDateTime($os.LastBootUpTime)
    return $uptime.Days
}

# Load System.Windows.Forms assembly
Add-Type -AssemblyName System.Windows.Forms

# Get system uptime in days
$uptime = Get-UptimeDays

# Define the log file path
$logFilePath = "C:/Windows/Temp/uptimelog.txt"

# Function to log messages to the file with date and time stamp
function Log-Message {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - $message"
    Add-Content -Path $logFilePath -Value $logEntry
}

# Log the current uptime
Log-Message "Current system uptime: $uptime days"

# Check if uptime is 10 days or more
if ($uptime -ge 10) {
    # Display dialog box for user choice with uptime in days
    $message = "System uptime is $uptime days. Do you want to reboot now?"
    Log-Message $message
    $choice = [System.Windows.Forms.MessageBox]::Show($message, "System Uptime Warning", [System.Windows.Forms.MessageBoxButtons]::YesNo)

    if ($choice -eq [System.Windows.Forms.DialogResult]::Yes) {
        # Log and reboot now
        Log-Message "User chose to reboot now."
        Restart-Computer -Force
    } else {
        Log-Message "User chose not to reboot now."
    }
}

# Check if uptime is 28 days or more
if ($uptime -ge 28) {
    # Display dialog box for user choice with uptime in days and countdown warning
    $message = "System uptime is $uptime days. The system will automatically reboot in 5 minutes."
    Log-Message $message
    [System.Windows.Forms.MessageBox]::Show($message, "System Uptime Warning", [System.Windows.Forms.MessageBoxButtons]::OK)
    $message = "Would you like to reboot now?"
    Log-Message $message
    $choice = [System.Windows.Forms.MessageBox]::Show($message, "System Uptime Warning", [System.Windows.Forms.MessageBoxButtons]::YesNo)

    if ($choice -eq [System.Windows.Forms.DialogResult]::Yes) {
        # Log and reboot now
        Log-Message "User chose to reboot now."
        Restart-Computer -Force
    } else {
        # Log and wait for 5 minutes before forcing reboot
        Log-Message "User chose not to reboot now. System will reboot in 5 minutes."
        Start-Sleep -Seconds 300
        Restart-Computer -Force
    }
}
