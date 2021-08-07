# DVDFabAutoRip

# Disclaimer
Note: I do not condone piracy, please use this only for backing up your own physical media you have bought. A lot of work goes into making a movie, make sure they get the support they need by buying your movies legally. 

# PowerShell
Documentation to be updated, powershell version [DVDFab.ps1](DVDFab.ps1) has been created, the VBScript is depreciated. The Script can be installed as a service by using the -Install Parameter when running the script. Please note when running as a service you will need to use the mobile DVDFab Remote app to monitor progress, this is due to the secure desktop no longer being supported on modern versions of windows, so you will not see the GUI. 

# Installation
Copy [DVDFab.ps1](DVDFab.ps1) to a location on your harddrive. 

Edit the following lines for your enviroment:


```
#Set DVDFab Location
$DVDFab= "C:\Program Files\DVDFab\DVDFab 12\DVDFab64.exe"
```
```
#Set DVD Drive Letter
$DVD= "`"D:\`""
```
Only the D needs to be changed if your Optical Drive is a different letter
```
#Get DVD Label Name for ISO File Name, Set Optical Drive Letter
$DVDLabel= Get-Volume -DriveLetter D| % FileSystemLabel
```
Edit the Folder Path for your enviroment, leaving the $DVDLabel.iso
```
#Set Destination Folder 
$Dest="`"E:\Videos\Movies\$DVDLabel.iso`""
```

Save your changes. 

Run PowerShell as an Administrator CD to the directory you saved the script. Type ".\DVDFab.ps1 -Install" DVDFabAutoRip will now be installed as a system service. 
You may want to change the service logon account to a local administrator account rather than the System account if you run into any issues. 

# Known Script Issues
 
 LiveUpdate.exe - LiveUpdate is a program that DVDFab is uses to check for and prompt you to install updates to the program. Currently there is no way to turn off update checks in DVDFab. When DVDFab is lauched it will check this, and leave liveupdate.exe open with a window for you to install until you confirm to install or manually close. The /CLOSE paramater for DVDFab.exe commandline does not pass thru to this update utility. So if there is an update the process will not continue as the script will be waiting for this to close. The old VBScript got around this by waiting for the Optical drive to be in a ready state, however this had more problems as it was a guessing game with delays as the drive is not in use when DVDFab first runs and if it as to pull decryption information from DVDFab Servers. I'm currently working on a process to watch for and close this when detected. 
 
 Errors, Prompts etc. - This one is not possible to fix and is just the nature of how DVDFab works. If a disc is not reading well you may or may not get a warning in DVDFab remote. If something seems off, just stop the script or DVDFabAuto Rip service in Services.msc and run it manually. 



# Sleep Issues
Some UDH Friendly Drives may have sleep issues where the drive will no longer respond. This is a known issue for LG WH14NS40 Drives with UHD Friendly firmware for example, the fix is to use LG_WH16NS60_1.00 firmware for most LG WH14NS40 Drives. Flashing firmware may brick your drive, use at your own risk. 

# Depreciated VBScript
[Click Here](/VBScript) if you are looking for the depreciated VBScript
