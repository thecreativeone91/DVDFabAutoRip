###                                       DVDFab AutoCloning Script                               ###
###                                           Update 7/14/2021                                    ###
###                    Requires DVDFab and a UHD Friendly Drive to Clone Blu ray Discs            ###
###                   ".\DVDFab.ps1 - Install" must be running as administrator to Install        ###
###                     Be Sure to Set the DVDFab Variables for your enviroment                   ###
### $DVDFab is the location of your DVDFab executable                                             ###
### $Mode is the mode to run DVDFab in see https://www.dvdfab.cn/manual/introduction/command-line ###
### $Dest is the Destination path for your copy/clone $DVD is your optical drive                  ###
###
###
 Param(
#[Parameter(Mandatory=$false)]
[Switch]$Install,
[Switch]$LiveUpdate
)
if($Install){
Write-Host 'Please Wait.. Installing DVDFabAutoRip Service'
Write-Host 'Downloading Chocolatey Package Manager.'
#Download and Install Choclatey Package Manager
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
Write-Host 'Done.. Creating Service with NSSM'
#Install Non-Sucking Service Manager from Choclatey
choco install nssm
#Copy our Script to a static location for Service
$ScriptPath= 'C:\DVDFabAutoRip\DVDFab.ps1'
#Make Folder (even if it's there)
New-Item C:\DVDFabAutoRip -ItemType Directory -Force
#Copy Current Script to folder
Copy-Item -Path $PSScriptRoot\DVDFab.ps1 -Destination $ScriptPath -Force
#Create Service with NSSM
$nssm = 'C:\ProgramData\chocolatey\lib\NSSM\tools\nssm.exe'
$ServiceName = 'DVDFabAutoRip'
$ServicePath = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
$ServiceArguments = '-ExecutionPolicy Bypass -NoProfile -File "{0}"' -f $ScriptPath
& $nssm install $ServiceName $ServicePath $ServiceArguments
&nssm set $ServiceName Description DVDFabAutoRip Service to watch for media in optical drive and launch DVDFab for Ripping
Start-Sleep -Seconds .5
# check the status... should be stopped
& $nssm status $ServiceName
# start things up!
& $nssm start $ServiceName
# verify it's running
& $nssm status $ServiceName
Write-Host 'Service is now installed'
Return}
if($LiveUpdate){
#kill LiveUpdate.exe which will prevent process from looping if an update is found
Start-Sleep -Seconds 300
Write-Host "Ending Liveupdate.exe"
Stop-Process -Name "LiveUpdate"
Start-Sleep -Seconds 300
Write-Host "Ending Liveupdate.exe"
Stop-Process -Name "LiveUpdate"
Return}
#Normal Script
#loop
While($true)
{
#Check CDDrive for Optical Disc
###            VARIABLES                       ###
### BE Sure to Check these for your enviroment ###
### These are required to work properly        ###
$Media= (Get-WMIObject -Class Win32_CDROMDrive -Property *).MediaLoaded
#Set DVDFab Location
$DVDFab= "C:\Program Files\DVDFab\DVDFab 12\DVDFab64.exe"
#Set DVDFab Mode
#Double Quotes required, DVDFab Commandline needs quotes https://www.dvdfab.cn/manual/introduction/command-line
$Mode="`"CLONE`""
#Set DVD Drive Letter
$DVD= "`"D:\`""
#Get DVD Label Name for ISO File Name, Set Optical Drive Letter
$DVDLabel= Get-Volume -DriveLetter D| % FileSystemLabel
#Set Destination Folder 
$Dest="`"E:\Videos\Movies\$DVDLabel.iso`""
#Check If DVD is in Drive and start DVDFab Cloning, waiting for process to end
If ($Media -eq $true) {
#Print That Drive is Ripping, Lauch DVDFab and Wait for DVDFab to close 
Write-Host 'Media is in Drive, Starting DVDFab Rip';
## Launch Script with switch to end LiveUpdate
"$PSScriptRoot\DVDFab.ps1 -LiveUpdate"
## Close Staticly set, not a Variable as the process will not work automacitly if DVDFab is not ending it's process
### It's also required to be able to run as a service, as we can no longer interact with applications running as a service
Start-Process $DVDFab -Wait -ArgumentList ('/Mode',$Mode,'/SRC',$DVD,'/DEST',$Dest,'/CLOSE')
Write-Host "Done Copying, Ejecting CD Tray if not already Ejected"
#Ejecting requires administrative rights
(New-Object -com "WMPlayer.OCX.7").cdromcollection.item(0).eject()

  }  Else {
#Print that Drive has no media and wait 30 seconds before looping
Write-Host 'Media is not in Drive, Continuing to check until media exists every 30 seconds';
Start-Sleep -s 30

} 
}
