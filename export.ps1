# LavaBlock Mod Export Script
# Reads version from info.json and creates an export folder

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$infoJsonPath = Join-Path $scriptDir "info.json"

# Read info.json
$info = Get-Content $infoJsonPath -Raw | ConvertFrom-Json
$modName = $info.name
$version = $info.version

# Target folder name (Factorio mod format: ModName_version)
$exportFolderName = "${modName}_${version}"
$parentDir = Split-Path -Parent $scriptDir
$exportPath = Join-Path $parentDir $exportFolderName

Write-Host "Mod: $modName"
Write-Host "Version: $version"
Write-Host "Export folder: $exportPath"

# Delete folder if it already exists
if (Test-Path $exportPath) {
    Write-Host "Deleting previous export folder..."
    Remove-Item $exportPath -Recurse -Force
}

# Create new folder
New-Item -ItemType Directory -Path $exportPath | Out-Null

# Copy files (excluding git and other unnecessary files)
$excludePatterns = @(
    ".git",
    ".gitignore",
    "export.ps1",
    "export.bat",
    "export.sh",
    "node_modules",
    "package.json",
    "package-lock.json",
    "space-age-template.json",
    "*.zip"
)

Get-ChildItem -Path $scriptDir -Recurse | ForEach-Object {
    $relativePath = $_.FullName.Substring($scriptDir.Length + 1)
    $shouldExclude = $false

    foreach ($pattern in $excludePatterns) {
        if ($relativePath -like $pattern -or $relativePath -like "$pattern\*" -or $relativePath -like "*\$pattern" -or $relativePath -like "*\$pattern\*") {
            $shouldExclude = $true
            break
        }
    }

    if (-not $shouldExclude) {
        $destPath = Join-Path $exportPath $relativePath
        if ($_.PSIsContainer) {
            if (-not (Test-Path $destPath)) {
                New-Item -ItemType Directory -Path $destPath | Out-Null
            }
        } else {
            $destDir = Split-Path -Parent $destPath
            if (-not (Test-Path $destDir)) {
                New-Item -ItemType Directory -Path $destDir -Force | Out-Null
            }
            Copy-Item $_.FullName $destPath
        }
    }
}

Write-Host ""
Write-Host "Export complete: $exportPath" -ForegroundColor Green
Write-Host ""

# Create ZIP using 7-Zip (with forward slashes for Linux/macOS compatibility)
$zipPath = "${exportPath}.zip"
if (Test-Path $zipPath) {
    Remove-Item $zipPath -Force
}

# Use 7-Zip - compresses folder contents with proper structure
$sevenZipPath = "C:\Program Files\7-Zip\7z.exe"
if (Test-Path $sevenZipPath) {
    Push-Location $parentDir
    & $sevenZipPath a -tzip $zipPath $exportFolderName
    Pop-Location
    Write-Host "ZIP complete: $zipPath" -ForegroundColor Green
} else {
    Write-Host "ERROR: 7-Zip not found: $sevenZipPath" -ForegroundColor Red
    Write-Host "Install 7-Zip from: https://www.7-zip.org/" -ForegroundColor Yellow
}

Read-Host "Press ENTER to exit"
