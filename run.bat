@echo off
REM filepath: /c:/Users/vhenr/WorkingArea/HenriquezProductions/odoov18-docker-template/run.bat

REM Run docker-compose
docker-compose up -d --build

REM Create logs directory if it doesn't exist
if not exist logs mkdir logs

REM Set max log size (10MB in bytes)
set maxsize=10485760

REM Check if log file exists and needs rotation
if exist logs\app.log (
    for %%I in (logs\app.log) do set size=%%~zI
    if !size! geq %maxsize% (
        for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (
            for /f "tokens=1-2 delims=: " %%h in ('time /t') do (
                ren "logs\app.log" "app-%%c%%a%%b%%h%%i.log"
            )
        )
        type nul > logs\app.log
    )
)

REM Start logging docker-compose output
start /B cmd /c "docker-compose logs -f >> logs\app.log"

echo [92mOdoo and PostgreSQL containers successfully created[0m