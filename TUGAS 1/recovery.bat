@echo off
title All-in-One Simulation Tool
color 0A

:: =====================================================
::  MAIN MENU
:: =====================================================
:menu
cls
echo ============================================
echo       ALL-IN-ONE SIMULATION TOOL
echo ============================================
echo.
echo   1. Setup (Generate Struktur Project)
echo   2. Recovery (Copy Data Backup)
echo   3. Exit
echo.
set /p pilih=Masukkan pilihan: 

if "%pilih%"=="1" goto setup
if "%pilih%"=="2" goto recovery
if "%pilih%"=="3" exit
goto menu


:: =====================================================
::  SETUP PROJECT SIMULASI
:: =====================================================
:setup
cls
echo [SETUP] Membuat struktur folder simulasi...
echo.

set "SOURCE=%USERPROFILE%\Desktop\project6\SimulasiDrive_D"
set "DEST=%USERPROFILE%\Desktop\project6\SimulasiDrive_C"

echo Sumber data  : %SOURCE%
echo Folder backup: %DEST%
echo.

mkdir "%SOURCE%" 2>nul
mkdir "%DEST%" 2>nul

echo Membuat 10 folder, 30 subfolder, dan 180 file...
echo.

for /L %%A in (1,1,10) do (
    mkdir "%SOURCE%\Folder_%%A" 2>nul

    :: ===== SUBFOLDER A =====
    mkdir "%SOURCE%\Folder_%%A\SubFolder_A" 2>nul

    echo PDF File  > "%SOURCE%\Folder_%%A\SubFolder_A\file_%%A_A.pdf"
    echo CSV File  > "%SOURCE%\Folder_%%A\SubFolder_A\file_%%A_A.csv"
    echo DOCX File > "%SOURCE%\Folder_%%A\SubFolder_A\file_%%A_A.docx"
    echo BAT File  > "%SOURCE%\Folder_%%A\SubFolder_A\file_%%A_A.bat"
    echo INI File  > "%SOURCE%\Folder_%%A\SubFolder_A\file_%%A_A.ini"
    echo PY File   > "%SOURCE%\Folder_%%A\SubFolder_A\file_%%A_A.py"

    :: ===== SUBFOLDER B =====
    mkdir "%SOURCE%\Folder_%%A\SubFolder_B" 2>nul

    echo PDF File  > "%SOURCE%\Folder_%%A\SubFolder_B\file_%%A_B.pdf"
    echo CSV File  > "%SOURCE%\Folder_%%A\SubFolder_B\file_%%A_B.csv"
    echo DOCX File > "%SOURCE%\Folder_%%A\SubFolder_B\file_%%A_B.docx"
    echo BAT File  > "%SOURCE%\Folder_%%A\SubFolder_B\file_%%A_B.bat"
    echo INI File  > "%SOURCE%\Folder_%%A\SubFolder_B\file_%%A_B.ini"
    echo PY File   > "%SOURCE%\Folder_%%A\SubFolder_B\file_%%A_B.py"

    :: ===== SUBFOLDER C (2 format diganti: DB & TXT) =====
    mkdir "%SOURCE%\Folder_%%A\SubFolder_C" 2>nul

    echo PDF File   > "%SOURCE%\Folder_%%A\SubFolder_C\file_%%A_C.pdf"
    echo CSV File   > "%SOURCE%\Folder_%%A\SubFolder_C\file_%%A_C.csv"
    echo DB File    > "%SOURCE%\Folder_%%A\SubFolder_C\file_%%A_C.db"
    echo TXT File   > "%SOURCE%\Folder_%%A\SubFolder_C\file_%%A_C.txt"
    echo DOCX File  > "%SOURCE%\Folder_%%A\SubFolder_C\file_%%A_C.docx"
    echo BAT File   > "%SOURCE%\Folder_%%A\SubFolder_C\file_%%A_C.bat"
)

echo.
echo ============================================
echo   Setup selesai!
echo   10 folder, 30 subfolder, 180 file dibuat.
echo ============================================
pause
goto menu


:: =====================================================
::  DATA RECOVERY
:: =====================================================
:recovery
cls
echo [RECOVERY] Menyalin data backup...
echo.

set "SOURCE=%USERPROFILE%\Desktop\project6\SimulasiDrive_D"
set "DESTROOT=%USERPROFILE%\Desktop\project6\SimulasiDrive_C"

:: Format tanggal universal
for /f "tokens=1-3 delims=/" %%a in ("%date%") do (
    set DD=%%a
    set MM=%%b
    set YYYY=%%c
)

:: Format jam
set HOUR=%TIME:~0,2%
set HOUR=%HOUR: =0%
set MIN=%TIME:~3,2%

set "DEST=%DESTROOT%\DataRecovery_%YYYY%%MM%%DD%_%HOUR%%MIN%"
set "LOGFILE=%DESTROOT%\recovery_log.txt"

mkdir "%DEST%" 2>nul

echo Menyalin file...
xcopy "%SOURCE%" "%DEST%" /E /H /C /I /Y >nul

:: Hitung isi
for /f %%A in ('dir "%DEST%" /s /b /a-d ^| find /c /v ""') do set FILECOUNT=%%A
for /f %%A in ('dir "%DEST%" /s /b /ad ^| find /c /v ""') do set FOLDERCOUNT=%%A

(
    echo ================================================
    echo                  RECOVERY LOG
    echo ================================================
    echo Tanggal : %DD%-%MM%-%YYYY%
    echo Waktu   : %HOUR%:%MIN%
    echo Sumber  : %SOURCE%
    echo Tujuan  : %DEST%
    echo Jumlah Folder : %FOLDERCOUNT%
    echo Jumlah File   : %FILECOUNT%
    echo Status  : BERHASIL
    echo ================================================
) >> "%LOGFILE%"

echo.
echo Recovery selesai!
echo Lokasi data:
echo %DEST%
echo Log dicatat ke:
echo %LOGFILE%
pause
goto menu