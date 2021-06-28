#DVDFab AutoCloning Script
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
