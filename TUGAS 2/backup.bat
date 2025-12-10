@echo off
echo PROSES DATA RECOVERY...
echo.

setlocal enabledelayedexpansion

:: ==============================
:: Folder sumber & tujuan
:: ==============================
set "sumber=%USERPROFILE%\Desktop\SimulasiDrive_D"
set "tujuan=%USERPROFILE%\Desktop\SimulasiDrive_C"

:: Nama backup aman (YYYYMMDD_HHMMSS)
for /f "tokens=1-3 delims=/- " %%a in ("%date%") do set YEAR=%%c& set MONTH=%%a& set DAY=%%b
for /f "tokens=1-3 delims=:." %%d in ("%time%") do set HOUR=%%d& set MINUTE=%%e& set SECOND=%%f
set "backup=Backup_%YEAR%%MONTH%%DAY%_%HOUR%%MINUTE%%SECOND%"
set "backup_dir=%tujuan%\%backup%"

:: Buat folder backup
mkdir "%backup_dir%" >nul 2>&1

echo Sumber: %sumber%
echo Tujuan: %backup_dir%
echo.

:: Hitung total file .pdf & .docx di SimulasiDrive_D
for /f %%A in ('dir /s /b "%sumber%\*.pdf" "%sumber%\*.docx" 2^>nul ^| find /c /v ""') do set total=%%A

if %total%==0 (
    echo Tidak ada file .pdf atau .docx ditemukan di "%sumber%"!
    pause
    exit /b 0
)

echo Total file yang akan disalin: %total%
echo.
set count=0
set total_size=0

:: File size log
echo FILE SIZE LOG > "%backup_dir%\filesize_log.txt"

:: ==============================
:: Copy file dari SimulasiDrive_D saja
:: ==============================
for /r "%sumber%" %%f in (*.pdf *.docx) do (
    set /a count+=1
    echo [!count!/%total%] Copy: %%~nxf

    :: Buat folder tujuan mulai dari SimulasiDrive_D
    set "relpath=%%~pf"
    set "relpath=!relpath:%sumber%\=!"  :: Hapus path sebelum SimulasiDrive_D
    mkdir "%backup_dir%\SimulasiDrive_D!relpath!" 2>nul

    :: Copy file
    copy "%%f" "%backup_dir%\SimulasiDrive_D!relpath!" >nul

    :: Log file size
    echo %%~nxf - %%~zf bytes >> "%backup_dir%\filesize_log.txt"
    set /a total_size+=%%~zf
)

echo.
echo Total file yang disalin: !count!
echo Total ukuran semua file (bytes): !total_size!
echo !total_size! > "%backup_dir%\total_size.txt"

:: ==============================
:: Membuat ZIP
:: ==============================
echo.
echo Membuat file ZIP...
powershell -Command "Compress-Archive -Path '%backup_dir%\SimulasiDrive_D\*' -DestinationPath '%backup_dir%\SimulasiDrive_D.zip' -Force"

echo File ZIP dibuat: %backup_dir%\SimulasiDrive_D.zip
echo.
echo BACKUP SELESAI
pause