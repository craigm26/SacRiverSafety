# PowerShell script to add Flutter to PATH permanently
# Run this script as Administrator

$flutterPath = "C:\Users\CraigM\flutter\bin"
$currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")

if ($currentPath -notlike "*$flutterPath*") {
    $newPath = "$currentPath;$flutterPath"
    [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
    Write-Host "Flutter path added to user PATH successfully!" -ForegroundColor Green
    Write-Host "Please restart your terminal/PowerShell for changes to take effect." -ForegroundColor Yellow
} else {
    Write-Host "Flutter path already exists in user PATH." -ForegroundColor Yellow
}

Write-Host "`nFlutter version:" -ForegroundColor Cyan
& "$flutterPath\flutter.bat" --version 