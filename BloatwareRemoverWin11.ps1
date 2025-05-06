# === POST-INSTALL CLEANUP SCRIPT v2.0 ===

$loggFil = "$env:USERPROFILE\Desktop\PostInstall-Cleanup.log"
Start-Transcript -Path $loggFil -Append
Write-Host "`nStarter post-reinstall opprydding..." -ForegroundColor Cyan
Write-Host "--------------------------------------------------"

# Deteksjon
$erLenovo = (Get-CimInstance -Class Win32_ComputerSystem).Manufacturer -match "Lenovo"
$erNvidia = Get-CimInstance Win32_VideoController | Where-Object { $_.Name -like "*NVIDIA*" }
$erAmd = Get-CimInstance Win32_VideoController | Where-Object { $_.Name -match "(AMD|Radeon)" }

if ($erLenovo) {
    Write-Host "Lenovo-PC oppdaget – OEM-opprydding og Lenovo System Update vil kjøres." -ForegroundColor Green
} else {
    Write-Host "Ikke en Lenovo-PC – hopper over Lenovo-opprydding." -ForegroundColor Yellow
}

# --- Bloatware-liste ---
$bloatwareApps = @(
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.BingNews",
    "Microsoft.BingWeather",
    "Microsoft.Todos",
    "Microsoft.YourPhone",
    "Clipchamp.Clipchamp",
    "Microsoft.MicrosoftOfficeHub",
    "AppUp.IntelGraphicsExperience",
    "Microsoft.GetHelp",
    "Microsoft.ZuneMusic",
    "Microsoft.WindowsAlarms",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.OutlookForWindows",
    "Microsoft.Copilot"
)

# Xbox-relaterte apper kun fjernes hvis verken Nvidia eller AMD GPU
if (-not $erNvidia -and -not $erAmd) {
    $bloatwareApps += @(
        "Microsoft.GamingApp",
        "Microsoft.XboxGamingOverlay",
        "Microsoft.Xbox.TCUI",
        "Microsoft.XboxSpeechToTextOverlay",
        "Microsoft.XboxIdentityProvider"
    )
}

Write-Host "`nFjerner Microsoft/UWP bloatware..." -ForegroundColor Cyan
foreach ($app in $bloatwareApps) {
    $pakken = Get-AppxPackage -Name $app -AllUsers
    if ($pakken) {
        try {
            $pakken | Remove-AppxPackage -AllUsers -ErrorAction Stop
            Write-Host "Fjernet: $app" -ForegroundColor Green
        } catch {
            Write-Host "Feil ved fjerning: $app" -ForegroundColor Red
        }
    } else {
        Write-Host "Ikke funnet eller allerede fjernet: $app" -ForegroundColor DarkGray
    }
}

# --- Installer Lenovo System Update ---
if ($erLenovo) {
    Write-Host "`nFjerner Lenovo OEM-programvare..." -ForegroundColor Cyan
    $lenovoApps = @(
        "LenovoHotkeys",
        "LenovoUtility",
        "LenovoCompanion",
        "LenovoVantage",
        "LenovoDiagnostics",
        "LenovoQuickOptimizer",
        "LenovoModernImController",
        "LenovoServiceBridge"
    )
    foreach ($app in $lenovoApps) {
        Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE Name LIKE '%$app%'" | ForEach-Object {
            Write-Host "Fjerner: $($_.Name)" -ForegroundColor Magenta
            $_.Uninstall()
        }
    }
    Write-Host "`nInstallerer Lenovo System Update..." -ForegroundColor Cyan
    winget install --id Lenovo.SystemUpdate -e --silent --accept-package-agreements --accept-source-agreements
}

# --- Installer Xbox- og spillklienter ved Nvidia eller AMD GPU og ikke Lenovo ---
if (($erNvidia -or $erAmd) -and -not $erLenovo) {
    Write-Host "`nSpill-PC oppdaget – installerer Xbox og ekstra spillklienter..." -ForegroundColor Cyan

    # Xbox app
    winget install --id Microsoft.XboxApp -e --silent --accept-package-agreements --accept-source-agreements

    # Gaming Services (manuell installasjon via AppX)
    Get-AppxPackage -allusers Microsoft.GamingServices | ForEach-Object {
        Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"
    }

    # Epic, Ubisoft, EA App
    $gameClients = @(
        "EpicGames.EpicGamesLauncher",
        "Ubisoft.Connect",
        "ElectronicArts.EADesktop"
    )
    foreach ($client in $gameClients) {
        winget install --id $client -e --silent --accept-package-agreements --accept-source-agreements
    }
}
