# Quick fix for Flutter PATH issues in current PowerShell session
# Run this script when flutter command is not recognized

$flutterPath = "C:\Users\CraigM\flutter\bin"

# Add Flutter to current session PATH if not already there
if ($env:PATH -notlike "*$flutterPath*") {
    $env:PATH += ";$flutterPath"
    Write-Host "Added Flutter to current session PATH" -ForegroundColor Green
} else {
    Write-Host "Flutter path already in current session PATH" -ForegroundColor Yellow
}

# Test if Flutter is working
try {
    $flutterVersion = & "$flutterPath\flutter.bat" --version 2>&1
    Write-Host "Flutter is working:" -ForegroundColor Green
    Write-Host $flutterVersion -ForegroundColor Cyan
} catch {
    Write-Host "Error: Flutter is not working properly" -ForegroundColor Red
    Write-Host "Please check your Flutter installation at: $flutterPath" -ForegroundColor Yellow
}

Write-Host "`nYou can now use 'flutter' commands in this session." -ForegroundColor Green 