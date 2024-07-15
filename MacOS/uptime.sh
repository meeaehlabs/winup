#!/bin/bash

# Function to ensure Finder is running
ensure_finder_running() {
  if ! pgrep -x "Finder" > /dev/null; then
    echo "Finder is not running. Starting Finder..."
    open /System/Library/CoreServices/Finder.app

    # Wait for Finder to start
    while ! pgrep -x "Finder" > /dev/null; do
      sleep 1
    done

    echo "Finder has started."
  else
    echo "Finder is already running."
  fi
}

# Ensure Finder is running
ensure_finder_running

# Check if bash is installed, and install if not
if ! command -v bash &> /dev/null; then 
  echo "Bash is not installed. Installing..." 
  sudo apt-get update 
  sudo apt-get install bash 
fi

# Prompt user to reboot if there are updates pending, or if the Mac
# has been online for more than 10 days. If uptime is > X days, 
# the script will force a restart.
if [ -n "$1" ]
then
	maxUptime=$1
else
	maxUptime=28
fi
timeout=300 # seconds until restart
OSVERSION=$(defaults read /System/Library/CoreServices/SystemVersion ProductVersion | awk '{print $1}')
OSMAJOR=$(echo "${OSVERSION}" | cut -d . -f1)
#OSMINOR=$(echo "${OSVERSION}" | cut -d . -f2)
if pgrep "RMM Notification Service"
then
	AppName="RMM Notification Service"
elif pgrep -f "Mac_Agent.app"
then
	AppName="Mac_Agent"
else
	AppName="Finder"
fi
echo "Using $AppName"
niceRestart(){ #
	echo "Restarting system now."
	osascript <<EOF
tell application "System Events" to set quitapps to name of every application process whose visible is true and name is not "Finder"
repeat with closeall in quitapps
	try
		with timeout of ${timeout} seconds
			quit application closeall
		end timeout
	end try
end repeat
with timeout of ${timeout} seconds
	tell application "Finder" to restart
end timeout
EOF
 	shutdown -r now
}
warningPrompt(){
	promptResponse=$( osascript <<EOF
tell application "$AppName"
	activate
	set buttonResponse to button returned of (display alert "Restart Warning" message "Please restart your Mac soon. It has been online for $uptimeDays days without rebooting." buttons {"Restart Now", "Restart Later"} default button "Restart Later")
end tell
return buttonResponse
EOF
)
	if [[ "$promptResponse" = "Restart Now" ]]
	then
		echo "Trying a \"nice\" restart."
		niceRestart
	fi	
}
tooLatePrompt(){
	osascript <<EOF
tell application "$AppName"
activate
	display alert "Restarting Your Computer" message "Your Mac has been online for more than the allowed maximum $maxUptime days without rebooting. It will restart in $timeout seconds. " buttons {"Restart Now"} default button "Restart Now" giving up after $timeout
end tell
EOF
	niceRestart
}
installPrompt(){
	promptResponse=$( osascript <<EOF
tell application "$AppName"
	activate
	set buttonResponse to button returned of (display alert "Restart Warning" message "Please restart. There are updates for your Mac that are waiting on a restart to complete." buttons {"Restart Now", "Restart Later"} default button "Restart Later")
end tell
return buttonResponse
EOF
)
	if [[ "$promptResponse" = "Restart Now" ]]
	then
		echo "Trying a \"nice\" restart."
		niceRestart
	fi	
}
uptimeRaw="$(uptime | grep day)"
#echo $uptimeRaw
if [[ -n "$uptimeRaw" ]]
then
    uptimeDays=$(echo "$uptimeRaw" | awk '{print $3}')
else
    uptimeDays=0
fi
echo "Mac uptime: $uptimeDays days."
echo "Warning days: 10"
echo "Force days: $maxUptime"
if [ $uptimeDays -ge $maxUptime ] 
then
	tooLatePrompt		# force reboot
elif [ $uptimeDays -ge 10 ]
then 
	warningPrompt		# give a warning
fi
