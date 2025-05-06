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
    "Microsoft.OutlookForWindows",
    "Microsoft.Copilot"
)

if (-not $erNvidia -and -not $erAmd) {
    $bloatwareApps += @(
        "Microsoft.GamingApp",
        "Microsoft.XboxGamingOverlay",
        "Microsoft.Xbox.TCUI",
        "Microsoft.XboxSpeechToTextOverlay",
        "Microsoft.XboxIdentityProvider",
        "Microsoft.WindowsFeedbackHub"
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

# --- Installer Xbox- og spillklienter ---
if (($erNvidia -or $erAmd) -and -not $erLenovo) {
    Write-Host "`nSpill-PC oppdaget – installerer Xbox og ekstra spillklienter..." -ForegroundColor Cyan

    winget install --id Microsoft.XboxApp -e --silent --accept-package-agreements --accept-source-agreements
    Get-AppxPackage -allusers Microsoft.GamingServices | ForEach-Object {
        Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"
    }
    winget install --id Microsoft.WindowsFeedbackHub -e --silent --accept-package-agreements --accept-source-agreements

    $gameClients = @(
        "EpicGames.EpicGamesLauncher",
        "Ubisoft.Connect",
        "ElectronicArts.EADesktop"
    )
    foreach ($client in $gameClients) {
        winget install --id $client -e --silent --accept-package-agreements --accept-source-agreements
    }
}

# --- Installer programmer ---
Write-Host "`nInstallerer standardprogrammer..." -ForegroundColor Cyan
$standardApps = @(
    "Google.Chrome",
    "Mozilla.Firefox",
    "Valve.Steam",
    "KeePassXCTeam.KeePassXC",
    "7zip.7zip",
    "Discord.Discord",
    "VideoLAN.VLC",
    "Spotify.Spotify",
    "TeamViewer.TeamViewer",
    "Notepad++.Notepad++",
    "Microsoft.VisualStudioCode",
    "PuTTY.PuTTY",
    "Microsoft.PowerToys",
    "Microsoft.PowerShell"
)
foreach ($app in $standardApps) {
    Write-Host "Installerer: $app" -ForegroundColor Gray
    winget install --id $app -e --silent --accept-package-agreements --accept-source-agreements
}

# --- Systeminnstillinger: språk, tastatur, tema, søkemotor, akselerasjon ---
Write-Host "`nOppdaterer språk, tastatur og datoformat..." -ForegroundColor Cyan
Set-WinUILanguageOverride -Language en-US
Set-WinUserLanguageList -LanguageList nb-NO,en-US -Force
Set-WinSystemLocale nb-NO
Set-Culture nb-NO
Set-WinHomeLocation -GeoId 177
Set-TimeZone "W. Europe Standard Time"

Write-Host "Setter mørkt tema og fjerner unødvendige elementer fra taskbar..." -ForegroundColor Cyan
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 0 -Force
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 0 -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarDa" -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarMn" -Value 0 -PropertyType DWord -Force
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0 -Force
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0 -Force

Write-Host "Setter Google som standardsøkemotor i Edge og Chrome..." -ForegroundColor Cyan
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Force | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "DefaultSearchProviderEnabled" -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "DefaultSearchProviderSearchURL" -Value "https://www.google.com/search?q={searchTerms}" -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "DefaultSearchProviderName" -Value "Google" -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "DefaultSearchProviderKeyword" -Value "google.com" -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "PromotionalTabsEnabled" -Value 0 -PropertyType DWord -Force

New-Item -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Force | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "DefaultSearchProviderEnabled" -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "DefaultSearchProviderSearchURL" -Value "https://www.google.com/search?q={searchTerms}" -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "DefaultSearchProviderName" -Value "Google" -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "DefaultSearchProviderKeyword" -Value "google.com" -Force

Write-Host "Deaktiverer hardware-akselerasjon i Edge og Chrome..." -ForegroundColor Cyan
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "HardwareAccelerationModeEnabled" -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "HardwareAccelerationModeEnabled" -Value 0 -PropertyType DWord -Force

Write-Host "`nOpprydding fullført. Logg lagret til: $loggFil" -ForegroundColor Green
Stop-Transcript
