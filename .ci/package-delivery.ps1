param(
    [string]$PackageName = "cangjie-ci-homework"
)

$ErrorActionPreference = "Stop"

$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$DistDir = Join-Path $ProjectRoot "dist"
$PackagePath = Join-Path $DistDir "$PackageName.zip"
$ManifestPath = Join-Path $DistDir "delivery-manifest.txt"

New-Item -ItemType Directory -Force -Path $DistDir | Out-Null
if (Test-Path $PackagePath) {
    Remove-Item -LiteralPath $PackagePath -Force
}

$items = @(
    "src",
    "tests",
    ".ci",
    "Jenkinsfile",
    "README.md",
    "target/add_test.exe",
    "target/example.cjo"
)

$manifest = @(
    "Cangjie CI/CD delivery package",
    "Package: $PackageName.zip",
    "GeneratedAt: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')",
    "",
    "Included files:"
)

foreach ($item in $items) {
    $path = Join-Path $ProjectRoot $item
    if (Test-Path $path) {
        $manifest += " - $item"
    }
}

Set-Content -LiteralPath $ManifestPath -Value $manifest -Encoding UTF8

$existingItems = @()
foreach ($item in $items) {
    $path = Join-Path $ProjectRoot $item
    if (Test-Path $path) {
        $existingItems += $path
    }
}
$existingItems += $ManifestPath

Compress-Archive -Path $existingItems -DestinationPath $PackagePath -Force

Write-Host "Delivery package created:"
Write-Host $PackagePath
