@setlocal enableextensions

reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\BoL /f

reg delete HKEY_LOCAL_MACHINE\SOFTWARE\BoL /f

rmdir %AppData%\BoL /s /q

mkdir %AppData%\BoL

cd /d "%~dp0"

cd BoL AppData

xcopy "*.bol" "%AppData%\BoL" /e /y /s /i

taskkill.exe /F /IM iexplore.exe /T

rundll32.exe InetCpl.cpl,ClearMyTracksByProcess 255

rundll32.exe InetCpl.cpl,ClearMyTracksByProcess 4351

rundll32 inetcpl.cpl ResetIEtoDefaults

netsh winsock reset

ipconfig /flushdns

gpupdate.exe /force