# combine-twee.ps1
# Combines all .twee source files into one file for importing into Twine Desktop.

$SourceDir = Join-Path $PSScriptRoot "src"
$OutputDir = Join-Path $PSScriptRoot "build"
$OutputFile = Join-Path $OutputDir "yumechat-import.twee"

if (-not (Test-Path $SourceDir)) {
    Write-Error "Source directory not found: $SourceDir"
    exit 1
}

if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
}

# Delete previous combined file.
if (Test-Path $OutputFile) {
    Remove-Item $OutputFile
}

$files = Get-ChildItem `
    -Path $SourceDir `
    -Filter "*.twee" `
    -File `
    -Recurse |
    Sort-Object FullName

if ($files.Count -eq 0) {
    Write-Error "No .twee files found in $SourceDir"
    exit 1
}

Write-Host ""
Write-Host "Combining Twee files..."
Write-Host ""

foreach ($file in $files) {

    $relative = $file.FullName.Substring($SourceDir.Length + 1)

    Write-Host "  + $relative"

    # Add a separator between source files.
    Add-Content `
        -Path $OutputFile `
        -Value "`r`n`r`n" `
        -Encoding UTF8

    Get-Content `
        -Path $file.FullName `
        -Raw |
        Add-Content `
            -Path $OutputFile `
            -Encoding UTF8
}

Write-Host ""
Write-Host "Done!"
Write-Host ""
Write-Host "Created:"
Write-Host "  $OutputFile"
Write-Host ""
Write-Host "Import this file into Twine Desktop."