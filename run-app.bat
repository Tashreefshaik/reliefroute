@echo off
echo Starting ReliefRoute App...
echo.

echo Step 1: Starting Android Emulator...
C:\flutter\flutter\bin\flutter emulators --launch Medium_Phone
timeout /t 15 /nobreak > nul

echo.
echo Step 2: Running Flutter app...
cd C:\reliefroute_fresh
C:\flutter\flutter\bin\flutter run

pause
