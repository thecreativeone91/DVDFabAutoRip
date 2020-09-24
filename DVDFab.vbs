Set objShell = CreateObject ("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShellApp = CreateObject("Shell.Application")
strResponse = vbYes
While strResponse = vbYes
	Call RunTransfer
'	strResponse = MsgBox("The import job is finished, please remove your BD/DVD. ", vbOKOnly, "BD Import")
	strResponse = vbYes
Wend
'MsgBox "BD Import Done."

Sub RunTransfer
	For Each objDrive In objFSO.Drives
		WScript.sleep 60
		If objDrive.DriveType = 4 Then
			While Not objDrive.IsReady
				WScript.Sleep 1000
			Wend
			If objFSO.FolderExists("E:\VIDEOS\MOVIES") = True Then
				objShell.Run """C:\Program Files\DVDFab 11\DVDFab64.exe"" /MODE ""BDCLONE"" /SRC ""D:\"" /DEST ""E:\VIDEOS\MOVIES"" /CLOSE"
				WScript.Sleep 7200000
			Else
				MsgBox "Could Not find Destination", vbOKOnly, "Folder not found"
			End If
			While Not objDrive.IsReady
				WScript.Sleep 1000
			Wend
			
		End If
	Next
End Sub
