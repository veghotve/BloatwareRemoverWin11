# This script removes bloatware from Windows 11, unpins them from the Start menu, and logs the removed apps to a file

# Define the path to the log file
$logPath = "$env:USERPROFILE\Desktop\bloatware-removal.log"

# Define the list of bloatware to remove
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
    "Microsoft.MicrosoftSolitaireCollection" # Microsoft Solitaire
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
    "Microsoft.XboxGameCallableUI"
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
    "Microsoft.Todo" # Microsoft To Do
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

# Unpin from Start Menu (by using layout reset)
Start-Process powershell -ArgumentList "Start-Process 'powershell' -ArgumentList 'Import-StartLayout -LayoutPath $env:windir\SystemApps\ShellExperienceHost_cw5n1h2txyewy\defaultlayout.xml -MountPath C:\'"

# Write the names of the removed apps to the log file
$removedApps | Out-File -FilePath $logPath

# Display a message to indicate that the script has completed
Write-Host "Bloatware removal complete. The following apps have been removed:" -ForegroundColor Green
$removedApps | ForEach-Object { Write-Host "- $_" }
Write-Host "A log of the removed apps has been saved to $logPath." -ForegroundColor Green
