param(
    [string]$SdkZip = "",
    [string]$SdkRoot = ".cangjie-sdk"
)

$ErrorActionPreference = "Stop"

$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$TargetDir = Join-Path $ProjectRoot "target"
New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null

function Use-CangjieSdk {
    param(
        [string]$ZipPath,
        [string]$RootPath
    )

    if ($env:CANGJIE_HOME -and (Test-Path (Join-Path $env:CANGJIE_HOME "envsetup.ps1"))) {
        . (Join-Path $env:CANGJIE_HOME "envsetup.ps1")
        return
    }

    if (-not $ZipPath) {
        throw "CANGJIE_HOME is not set and no SDK zip was provided. Pass -SdkZip or set CANGJIE_HOME."
    }

    $ResolvedZip = Resolve-Path $ZipPath
    $ResolvedRoot = Join-Path $ProjectRoot $RootPath

    if (-not (Test-Path (Join-Path $ResolvedRoot "cangjie\envsetup.ps1"))) {
        New-Item -ItemType Directory -Force -Path $ResolvedRoot | Out-Null
        Expand-Archive -Path $ResolvedZip -DestinationPath $ResolvedRoot -Force
    }

    . (Join-Path $ResolvedRoot "cangjie\envsetup.ps1")
}

Use-CangjieSdk -ZipPath $SdkZip -RootPath $SdkRoot

Write-Host "Cangjie compiler version:"
cjc -v

$OutputBase = Join-Path $TargetDir "add_test"
$SourceFile = Join-Path $ProjectRoot "src\add.cj"
$TestFile = Join-Path $ProjectRoot "tests\add_test.cj"

Write-Host "Compiling unit test..."
cjc $SourceFile $TestFile --test -o $OutputBase

$TestExe = $OutputBase
if (-not (Test-Path $TestExe)) {
    $WindowsExe = "$OutputBase.exe"
    if (Test-Path $WindowsExe) {
        $TestExe = $WindowsExe
    } else {
        throw "Expected test executable was not created: $OutputBase or $WindowsExe"
    }
} elseif (-not (Test-Path "$OutputBase.exe")) {
    Copy-Item -Path $OutputBase -Destination "$OutputBase.exe" -Force
    $TestExe = "$OutputBase.exe"
}

Write-Host "Running unit test..."
& $TestExe
