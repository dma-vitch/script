' ---------- 
' Начало основной секции. Отсюда начнется выполнение при запуске скрипта. 
Set FSO = CreateObject("Scripting.FileSystemObject")
' директория, где будут храниться бэкапы. Вы должны вписать свою директорию
' вместо "C:\mule-standalone-3.6.1\logs"
sDir = "C:\mule-standalone-3.6.1\logs"
Set objDir = GetFolder(sDir)
'получаем количество дней старше которых нужно удалять
iDays = Int(Wscript.arguments.Item(0))
DeleteOlderFiles objDir,iDays
'DeleteOlderFiles(objDir)
' ---------- Секция функций

' Получить файл
Function GetFile(sFile)
 On Error Resume Next
 
 Set FSO = CreateObject("Scripting.FileSystemObject")
 Set GetFile = FSO.GetFile(sFile)
 if err.number <> 0 then
	WScript.Echo "Error Opening file " & sFile & VBlf & "["&Err.Description&"]"
	Wscript.Quit Err.number
 end if
End Function 

' Получить папку
Function GetFolder (sFolder)
 On Error Resume Next
 
 Set GetFolder = FSO.GetFolder(sFolder)
 if err.number <> 0 then
	WScript.Echo "Error Opening folder " & sFolder & VBlf & "["&Err.Description&"]"
	Wscript.Quit Err.number
 end if
End Function 

' удалить один файл (имя файла передается в sFile)
Sub DeleteFile(sFile)
 On Error Resume Next

 FSO.DeleteFile sFile, True
 if err.number <> 0 then
	WScript.Echo "Error Deleteing file " & sFile & VBlf & "["&Err.Description&"]"
	Wscript.Quit Err.number
 end if
End Sub 

' Удалить файлы старше 14 дней
'Sub DeleteOlderFiles(objDir)
Sub DeleteOlderFiles(objDir,iDays)
    ' просматриваем все файлы в директории
	for each efile in objDir.Files		
		' используем DateLastModified, а не DateCreated, поскольку
		' DateCreated не всегда возвращает правильную дату
		FileDate = efile.DateLastModified 
		Age = DateDiff("d",Now,FileDate)		
		' в данном случае возраст файла не больше iDays дней
		If Abs(Age)>iDays Then 
		'If Abs(Age)>7 Then		
		'WScript.Echo efile
			DeleteFile(efile)
		End If		
	next 
End Sub	