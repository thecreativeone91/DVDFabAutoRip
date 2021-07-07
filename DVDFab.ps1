#DVDFab AutoCloning Script
#Installer, must be running as administrator to Install
 Param(
#[Parameter(Mandatory=$false)]
[Switch]$Install
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
#Normal Script
#loop
While($true)
{
#Check CDDrive for Optical Disc
$Media= (Get-WMIObject -Class Win32_CDROMDrive -Property *).MediaLoaded
#Set DVDFab Location
$DVDFab= "C:\Program Files\DVDFab\DVDFab 12\DVDFab64.exe"
#Set DVDFab Mode
#Double Quotes required, DVDFab Commandline needs quotes https://www.dvdfab.cn/manual/introduction/command-line
$Mode="`"BDCLONE`""
#Set Destination Folder 
$Dest="`"E:\Videos\Movies`""
#Set DVD Drive Letter
$DVD= "`"D:\`""
#Check If DVD is in Drive and start DVDFab Cloning, waiting for process to end

If ($Media -eq $true) {
#Print That Drive is Ripping, Lauch DVDFab and Wait for DVDFab to close 
Write-Host 'Media is in Drive, Starting DVDFab Rip';
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
