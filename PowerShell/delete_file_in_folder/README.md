del_file_in_folder
--------------

Requirement:
--------------
Version of PowerShell (2.0 or higher).

Version of Windows Server( 2008 or higher).

Features:
----------

Delete file by age.
Age and path set as arguments

Installation notes:
-------------------
- run PowerShell

- Change policy execution of PowerShell
```
Set-ExecutionPolicy Unrestricted
```

- Put script in working dir, example `C:\!adm\script`

- Create Windows Task Sheduler for run this script or run manual

Usage:
----------

Delete files olds 4 days at current date

`
del_file_in_folder_function.ps1 C:\logs 4
`