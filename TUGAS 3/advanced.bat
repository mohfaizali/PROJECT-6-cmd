@echo off
setlocal enabledelayedexpansion

:: ==============================
:: KONFIGURASI DEFAULT
:: ==============================
set "TARGET=%USERPROFILE%\Desktop\Backup"
set "SMTP_USER=faizmohamad17208@gmail.com"
set "SMTP_PASS=sngl feuc qysy nwzn"
set "EMAIL_TO=faizhajiali@gmail.com"

:MENU
cls
echo ==============================
echo SCRIPT BACKUP INTERAKTIF
echo ==============================
echo 1. Backup Sekali
echo 2. Backup Otomatis Tiap X Menit
echo 3. Keluar
echo ==============================
set /p choice="Pilih opsi (1-3): "

if "%choice%"=="1" goto SELECT_SOURCE_ONCE
if "%choice%"=="2" goto SELECT_SOURCE_LOOP
if "%choice%"=="3" exit
goto MENU

:: ==============================
:: Pilih folder sumber (sekali)
:: ==============================
:SELECT_SOURCE_ONCE
set /p SOURCE="Masukkan path folder yang ingin di-backup (contoh: C:\Folder\SimulasiDrive_D): "
if not exist "%SOURCE%" (
    echo Folder tidak ditemukan! Silakan masukkan lagi.
    goto SELECT_SOURCE_ONCE
)
call :DO_BACKUP
pause
goto MENU

:: ==============================
:: Pilih folder sumber (loop)
:: ==============================
:SELECT_SOURCE_LOOP
set /p SOURCE="Masukkan path folder yang ingin di-backup (contoh: C:\Folder\SimulasiDrive_D): "
if not exist "%SOURCE%" (
    echo Folder tidak ditemukan! Silakan masukkan lagi.
    goto SELECT_SOURCE_LOOP
)
set /p INTERVAL="Masukkan interval backup (menit): "
set /a INTERVAL_SEC=%INTERVAL%*60
echo Backup otomatis dimulai. Tekan Ctrl+C untuk berhenti.
:LOOP
call :DO_BACKUP
timeout /t %INTERVAL_SEC% >nul
goto LOOP

:: ==============================
:: Subroutine Backup
:: ==============================
:DO_BACKUP
:: ==============================
:: Buat nama backup dengan timestamp
:: ==============================
for /f "tokens=1-3 delims=/- " %%a in ("%date%") do set YEAR=%%c& set MONTH=%%a& set DAY=%%b
for /f "tokens=1-3 delims=:." %%d in ("%time%") do set HOUR=%%d& set MINUTE=%%e& set SECOND=%%f

set "BACKUP_NAME=Backup_%YEAR%%MONTH%%DAY%_%HOUR%%MINUTE%%SECOND%"
set "BACKUP_DIR=%TARGET%\%BACKUP_NAME%"

:: ==============================
:: Buat folder backup
:: ==============================
mkdir "%BACKUP_DIR%" >nul 2>&1

:: ==============================
:: Incremental backup
:: ==============================
echo Melakukan incremental backup dari "%SOURCE%" ke "%BACKUP_DIR%"...
xcopy "%SOURCE%\*" "%BACKUP_DIR%\" /D /E /C /I /Y >nul

:: ==============================
:: ZIP otomatis
:: ==============================
echo Membuat ZIP backup...
powershell -Command "Compress-Archive -Path '%BACKUP_DIR%\*' -DestinationPath '%BACKUP_DIR%.zip' -Force"

:: ==============================
:: Kirim email notifikasi
:: ==============================
powershell -ExecutionPolicy Bypass -File "%~dp0send_email.ps1" ^
    -smtpUser "%SMTP_USER%" ^
    -smtpPass "%SMTP_PASS%" ^
    -to "%EMAIL_TO%" ^
    -subject "Backup Selesai: %BACKUP_NAME%" ^
    -body "Backup folder %SOURCE% selesai. File ZIP: %BACKUP_DIR%.zip"

echo Backup %BACKUP_NAME% selesai!
echo.
goto :eof