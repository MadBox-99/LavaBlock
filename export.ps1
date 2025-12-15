# LavaBlock Mod Export Script
# Kiolvassa a verziót az info.json-ból és létrehoz egy exportált mappát

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$infoJsonPath = Join-Path $scriptDir "info.json"

# info.json beolvasása
$info = Get-Content $infoJsonPath -Raw | ConvertFrom-Json
$modName = $info.name
$version = $info.version

# Cél mappa neve (Factorio mod format: ModName_version)
$exportFolderName = "${modName}_${version}"
$parentDir = Split-Path -Parent $scriptDir
$exportPath = Join-Path $parentDir $exportFolderName

Write-Host "Mod: $modName"
Write-Host "Verzio: $version"
Write-Host "Export mappa: $exportPath"

# Ha már létezik a mappa, töröljük
if (Test-Path $exportPath) {
    Write-Host "Korabbi export mappa torlese..."
    Remove-Item $exportPath -Recurse -Force
}

# Új mappa létrehozása
New-Item -ItemType Directory -Path $exportPath | Out-Null

# Fájlok másolása (kihagyva a git és egyéb felesleges fájlokat)
$excludePatterns = @(
    ".git",
    ".gitignore",
    "export.ps1",
    "export.bat",
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
Write-Host "Export kesz: $exportPath" -ForegroundColor Green
Write-Host ""

# Opcionális: ZIP létrehozása
$zipPath = "${exportPath}.zip"
if (Test-Path $zipPath) {
    Remove-Item $zipPath -Force
}
Compress-Archive -Path $exportPath -DestinationPath $zipPath
Write-Host "ZIP kesz: $zipPath" -ForegroundColor Green

Read-Host "Nyomj ENTER-t a kilepeshez"
