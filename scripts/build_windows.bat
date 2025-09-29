@echo off


::delete dist folder
rmdir /s /q dist

echo "Windows: 1/3: apply plugins..."

call "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" ./scripts/windows_installer.iss