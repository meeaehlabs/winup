# winup
script to manage excessive uptime on windows computers


To use either windows or mac remove files from the folders and store them as below 
    
    Windows Use 
        store all files in C:\Windows\Temp\uptime.ps1
        C:\Windows\Temp\uptimerun.bat
    Run the .bat file to create new directory copy files to directory and setup a system scheduled task 


    MacOS Use 
        store the uptime.sh file in the /tmp/uptime.sh
        the com.metric.uptime.plist also in the /tmp/com.metric.uptime.plist

        finally run the below commands 
        cp /tmp/uptime.sh /Users/Shared
        cp /tmp/com.metric.uptime.plist /Library/LaunchDaemons
        sudo launchctl load /Library/LaunchDaemons/com.metric.uptime.plist
    this will store the uptime bash script in the shared users directory and will put the plist in the LaunchDaemons directory so that it will run on a system schedule
both schedules mac and windows are form 9am system time 
