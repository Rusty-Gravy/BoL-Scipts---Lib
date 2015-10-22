@echo off

del /S /F /Q %APPDATA%\BoL
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\BoL" /f