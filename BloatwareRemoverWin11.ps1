# This script removes bloatware from Windows 11 and logs the removed apps to a file

# Define the path to the log file
$logPath = "$env:USERPROFILE\Desktop\bloatware-removal.log"

# Define the list of bloatware to remove with corrected names
$bloatware = @(
    "Microsoft.Office.OneNote"
    "Microsoft.SkypeApp"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"
    "Microsoft.BingWeather"
    "Microsoft.Office.Sway"
    "Microsoft.Office.Desktop"
    "Microsoft.MicrosoftStickyNotes"
    "Microsoft.ScreenSketch"
    "Microsoft.MicrosoftSolitaireCollection" # Microsoft Solitaire Collection
    "Microsoft.MixedReality.Portal"
    "Microsoft.People"
    "Microsoft.Windows.Photos"
    "Microsoft.WindowsAlarms"
    "Microsoft.WindowsCalculator"
    "Microsoft.WindowsCamera"
    "Microsoft.WindowsMaps"
    "Microsoft.WindowsSoundRecorder"
    "Microsoft.WindowsFeedbackHub"
    "Microsoft.Xbox.TCUI"
    "Microsoft.ZuneMusic"
    "Microsoft.Music.Preview"
    "Microsoft.XboxGameCallableUI_1000.22000.1.0_neutral_neutral_cw5n1h2txyewy" # Correct Xbox Game Callable UI
    "Microsoft.XboxSpeechToTextOverlay_1.21.13002.0_x64__8wekyb3d8bbwe" # Xbox Speech to Text Overlay
    "Microsoft.XboxIdentityProvider"
    "Microsoft.BingTravel"
    "Microsoft.BingHealthAndFitness"
    "Microsoft.BingFoodAndDrink"
    "Microsoft.BingFinance"
    "Microsoft.3DBuilder"
    "Microsoft.BingNews"
    "Microsoft.XboxApp" # Xbox App
    "Microsoft.BingSports"
    "Microsoft.Getstarted" # Get Started
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.BioEnrollment"
    "Microsoft.WindowsStore"
    "Microsoft.WindowsPhone"
    "Microsoft.Todos_0.55.42812.0_x64__8wekyb3d8bbwe" # Correct Microsoft To Do
    "Microsoft.Clipchamp" # Clipchamp
    "Microsoft.LinkedIn" # LinkedIn
    "Microsoft.549981C3F5F10" # Cortana
    "Microsoft.GetHelp" # Get Help
    "Microsoft.windowscommunicationsapps" # Mail and Calendar
    "Microsoft.Teams" # Microsoft Teams
    "Microsoft.YourPhone" # Phone Link
)

# Initialize an array to store the names of the removed apps
$removedApps = @()

# Loop through each bloatware and remove it
foreach ($app in $bloatware) {
    $package = Get-AppxPackage -Name $app
    if ($package -ne $null) {
        $removedApps += $package.Name
        $package | Remove-AppxPackage
    }
}

# Remove the 3D Viewer app (not included in the above list)
$package = Get-AppxPackage -Name Microsoft.Windows3DViewer
if ($package -ne $null) {
    $removedApps += $package.Name
    $package | Remove-AppxPackage
}

# Remove the Xbox Game Bar
$package = Get-AppxPackage -Name Microsoft.XboxGameOverlay
if ($package -ne $null) {
    $removedApps += $package.Name
    $package | Remove-AppxPackage
}
$package = Get-AppxPackage -Name Microsoft.XboxGamingOverlay
if ($package -ne $null) {
    $removedApps += $package.Name
    $package | Remove-AppxPackage
}

# Write the names of the removed apps to the log file
$removedApps | Out-File -FilePath $logPath

# Display a message to indicate that the script has completed
Write-Host "Bloatware removal complete. The following apps have been removed:" -ForegroundColor Green
$removedApps | ForEach-Object { Write-Host "- $_" }
Write-Host "A log of the removed apps has been saved to $logPath." -ForegroundColor Green
