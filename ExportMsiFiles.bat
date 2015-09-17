@rem MrIkes
@rem ExportMsiFiles

@echo off
cls

set name=Export MSI Log
set ver=0.2
set DATESTAMP=%DATE:~0,2%-%DATE:~3,2%-%DATE:~6,4%
set TIMESTAMP=%TIME:~0,2%-%TIME:~3,2%-%TIME:~6,2%
set winserv=NAME_OF_YOUR_SERVER

set folder=%DATESTAMP%-%TIMESTAMP%

if exist %TEMP%\logEMF.txt del %TEMP%\logEMF.txt
echo @@ %name% %ver% >> %TEMP%\logEMF.txt
echo @@ Initialization... >> %TEMP%\logEMF.txt

if exist \\%winserv%\logs\%USERNAME% echo @@@@ Folder FOUND >> %TEMP%\logEMF.txt
if not exist \\%winserv%\logs\%USERNAME% echo @@@@ Folder MISSING >> %TEMP%\logEMF.txt
if not exist \\%winserv%\logs\%USERNAME% mkdir \\%winserv%\logs\%USERNAME%

echo @@ Export Data... >> %TEMP%\logEMF.txt

echo @@@@ User = %USERNAME% >> %TEMP%\logEMF.txt
echo @@@@ Windir = %WINDIR%\Temp >> %TEMP%\logEMF.txt

mkdir \\%winserv%\logs\%USERNAME%\%folder%
xcopy /Y %WINDIR%\Temp\MSI*.log \\%winserv%\logs\%USERNAME%\%folder%\ >> %TEMP%\logEMF.txt

regedit /e %TEMP%\tmp.txt "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Uninstall"
regedit /e %TEMP%\tmp2.txt "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall"
regedit /e %TEMP%\tmp3.txt "HKEY_LOCAL_MACHINE\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"

if exist %TEMP%\tmp.txt find "DisplayName" %TEMP%\tmp.txt > %TEMP%\tmp4.txt
if exist %TEMP%\tmp2.txt find "DisplayName" %TEMP%\tmp2.txt >> %TEMP%\tmp4.txt
if exist %TEMP%\tmp3.txt find "DisplayName" %TEMP%\tmp3.txt >> %TEMP%\tmp4.txt

for /f "tokens=2 delims==" %%a in (%TEMP%\tmp4.txt) do echo %%~a >> %TEMP%\tmp5.txt

sort %TEMP%\tmp5.txt > \\%winserv%\logs\%USERNAME%\%folder%\logInstall.txt

xcopy /Y %TEMP%\logEMF.txt \\%winserv%\logs\%USERNAME%\%folder%\

del %TEMP%\logEMF.txt 
del %TEMP%\tmp*.txt
