@setlocal enableextensions
@echo off
title Bot of Legends Pre Requsite Installer - KorteX
echo This will automaticlly download and Install the following:
echo.
echo DirectX June 2010
echo Visual Studio C++ 2010 Redist x86
echo Visual Studio C++ 2012 Redist x86
echo Visual Studio C++ 2013 Redist x86
echo.
echo.
echo Please allow a few minutes for each package to download and install
echo.
echo.
cd /d "%~dp0"
cd BoL
cd Tools
mkdir temp
copy wget.exe temp
cd temp
echo Downloading DirectX
wget --no-check-certificate -q http://download.microsoft.com/download/8/4/A/84A35BF1-DAFE-4AE8-82AF-AD2AE20B6B14/directx_Jun2010_redist.exe
echo Installing DirectX
START /WAIT "Extract DirectX June 2010 SDK" "directx_Jun2010_redist.exe" /C /T:%TEMP%/dx /Q
START /WAIT "Installing DirectX June 2010 SDK" "%TEMP%\dx\DXSETUP.exe" /silent
echo Downloading VS 2010
wget --no-check-certificate -q http://download.microsoft.com/download/5/B/C/5BC5DBB3-652D-4DCE-B14A-475AB85EEF6E/vcredist_x86.exe
echo Installing VS 2010
ren "vcredist_x86.exe" "2010.exe"
2010.exe /q /norestart
echo Downloading VS 2012
wget --no-check-certificate -q http://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x86.exe
echo Installing VS 2012
ren "vcredist_x86.exe" "2012.exe"
2012.exe /q /norestart
echo Downloading VS 2013
wget --no-check-certificate -q http://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe
echo Installing VS 2013
ren "vcredist_x86.exe" "2013.exe"
2013.exe /q /norestart
cd..
ping 123.45.67.89 -n 1 -w 5000 > nul
rmdir temp /q /s
echo Installation Complete
pause