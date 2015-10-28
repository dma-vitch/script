'*******************************************************************
' Имя: MonitorFolder.vbs
' Язык: VBScript
' версия 2.0
' Описание: Контроль даты и времени последнего изменения папки и вывод сообщения при изменении
'            
'*******************************************************************
Option Explicit
 
' Объявляем переменные

Dim FSO            ' Объект FileSystemObject
Dim Folder
Dim TextStream
Dim objShellApp

Dim InPath
Dim V_DateLast
Dim Str

' Задаем путь к папке, за которой осуществляем контроль
'-------------
InPath = "С:\test"

' Получаем объект FSO.Folder, для чтения даты и времени последнего изменения папки - [DT]
'-------------
Set FSO = CreateObject("Scripting.FileSystemObject")
Set Folder = FSO.GetFolder(InPath)
V_DateLast = Folder.DateLastModified

' Пробуем открыть файл ".\Rezult.txt" и считать предыдущее значение [DT]
'-------------
Set TextStream = FSO.OpenTextFile(".\Rezult.txt", 1, True)
Str = vbNullString
While Not TextStream.AtEndOfLine
    Str = Str & TextStream.Read(1)
Wend
TextStream.Close

'MsgBox Str & "." & vbCrLf & V_DateLast & "."

' Если файла ".\Rezult.txt" еще не было, создаем его и пишем текущее значение [DT]
'-------------
If Str="" then
 Set TextStream = FSO.OpenTextFile(".\Rezult.txt", 2, True)
 TextStream.WriteLine V_DateLast
 TextStream.Close
 WScript.Quit(0)
End if

' Если текущее значение [DT] не равно предыдущему (произошли изменения в папке), то выводим сообщение
'-------------
If StrComp(V_DateLast, Str,1) <> 0 then
 MsgBox "Произошли изменения в папке: " & InPath

 '... и открываем папку
 Set objShellApp = CreateObject("Shell.Application")
 objShellApp.Explore(InPath)

 Set TextStream = FSO.OpenTextFile(".\Rezult.txt", 2, True)
 TextStream.WriteLine V_DateLast
 TextStream.Close
 WScript.Quit(0)
End If

'WScript.Echo "Конец"
WScript.Quit(0)

'************************* Конец ***********************************