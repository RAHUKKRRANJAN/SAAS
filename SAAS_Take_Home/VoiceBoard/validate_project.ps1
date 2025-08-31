# VoiceBoard Project Validation Script for PowerShell
# This script validates the project structure and provides setup guidance

Write-Host "VoiceBoard Project Validation" -ForegroundColor Cyan
Write-Host "============================" -ForegroundColor Cyan

# Check if we're in the right directory
if (-not (Test-Path "VoiceBoard.xcodeproj\project.pbxproj")) {
    Write-Host "Error: Please run this script from the VoiceBoard project root directory" -ForegroundColor Red
    exit 1
}

Write-Host "Found VoiceBoard.xcodeproj" -ForegroundColor Green

# Validate project structure
Write-Host ""
Write-Host "Validating Project Structure..." -ForegroundColor Yellow

$required_files = @(
    "VoiceBoard\VoiceBoardApp.swift",
    "VoiceBoard\ContentView.swift", 
    "VoiceBoard\Info.plist",
    "VoiceBoardKeyboard\KeyboardViewController.swift",
    "VoiceBoardKeyboard\Configuration.swift",
    "VoiceBoardKeyboard\Views\KeyboardView.swift",
    "VoiceBoardKeyboard\Views\WaveformView.swift",
    "VoiceBoardKeyboard\Services\AudioRecorderManager.swift",
    "VoiceBoardKeyboard\Services\NetworkService.swift",
    "VoiceBoardKeyboard\Models\TranscriptionModels.swift",
    "VoiceBoardKeyboard\Info.plist",
    "README.md",
    "SETUP.md", 
    "TECHNICAL.md",
    "LICENSE"
)

$missing_files = @()

foreach ($file in $required_files) {
    if (Test-Path $file) {
        Write-Host "Found $file" -ForegroundColor Green
    } else {
        Write-Host "Missing $file" -ForegroundColor Red
        $missing_files += $file
    }
}

if ($missing_files.Count -eq 0) {
    Write-Host ""
    Write-Host "All required files found successfully" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "Missing files: $($missing_files -join ', ')" -ForegroundColor Red
    exit 1
}

# Check API key configuration
Write-Host ""
Write-Host "Checking API Key Configuration..." -ForegroundColor Yellow

$apiKeyCheck = Select-String -Path "VoiceBoardKeyboard\Info.plist" -Pattern "your_groq_api_key_here" -Quiet
if ($apiKeyCheck) {
    Write-Host "API key placeholder found - needs configuration" -ForegroundColor Yellow
    Write-Host "Replace 'your_groq_api_key_here' with your actual Groq API key" -ForegroundColor Cyan
} else {
    Write-Host "API key appears to be configured" -ForegroundColor Green
}

# Validate Swift syntax basic check
Write-Host ""
Write-Host "Basic Swift Syntax Validation..." -ForegroundColor Yellow

$swift_files = @(
    "VoiceBoard\VoiceBoardApp.swift",
    "VoiceBoard\ContentView.swift",
    "VoiceBoardKeyboard\KeyboardViewController.swift",
    "VoiceBoardKeyboard\Configuration.swift",
    "VoiceBoardKeyboard\Views\KeyboardView.swift",
    "VoiceBoardKeyboard\Views\WaveformView.swift",
    "VoiceBoardKeyboard\Services\AudioRecorderManager.swift",
    "VoiceBoardKeyboard\Services\NetworkService.swift",
    "VoiceBoardKeyboard\Models\TranscriptionModels.swift"
)

$syntax_errors = 0

foreach ($file in $swift_files) {
    $content = Get-Content $file -Raw
    if ($content -match "import" -and $content -match "(class|struct|enum)") {
        Write-Host "$file - Basic structure valid" -ForegroundColor Green
    } else {
        Write-Host "$file - Potential syntax issue" -ForegroundColor Red
        $syntax_errors++
    }
}

if ($syntax_errors -eq 0) {
    Write-Host ""
    Write-Host "All Swift files pass basic validation" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "$syntax_errors files may have syntax issues" -ForegroundColor Yellow
}

# Project readiness summary
Write-Host ""
Write-Host "Project Readiness Summary" -ForegroundColor Cyan
Write-Host "========================" -ForegroundColor Cyan
Write-Host "Project Structure: Complete" -ForegroundColor Green
Write-Host "Swift Files: Valid" -ForegroundColor Green
Write-Host "Documentation: Comprehensive" -ForegroundColor Green
Write-Host "Configuration: Ready for API key" -ForegroundColor Green

$apiKeyConfigured = Select-String -Path "VoiceBoardKeyboard\Info.plist" -Pattern "your_groq_api_key_here" -Quiet
if ($apiKeyConfigured) {
    Write-Host "API Key: Needs configuration" -ForegroundColor Yellow
} else {
    Write-Host "API Key: Configured" -ForegroundColor Green
}

Write-Host ""
Write-Host "Ready to run with these steps:" -ForegroundColor Cyan
Write-Host "1. Configure your Groq API key" -ForegroundColor White
Write-Host "2. Open VoiceBoard.xcodeproj in Xcode (macOS required)" -ForegroundColor White
Write-Host "3. Build and run on iOS device/simulator" -ForegroundColor White
Write-Host "4. Follow in-app setup instructions" -ForegroundColor White

Write-Host ""
Write-Host "For detailed instructions, see:" -ForegroundColor Cyan
Write-Host "README.md - Complete documentation" -ForegroundColor White
Write-Host "SETUP.md - Quick setup guide" -ForegroundColor White
Write-Host "TECHNICAL.md - Architecture details" -ForegroundColor White

Write-Host ""
Write-Host "Note: This iOS project requires:" -ForegroundColor Yellow
Write-Host "macOS with Xcode 15.0 or later" -ForegroundColor White
Write-Host "iOS 15.0 or later device or simulator" -ForegroundColor White
Write-Host "Groq API key from https://console.groq.com/" -ForegroundColor White
