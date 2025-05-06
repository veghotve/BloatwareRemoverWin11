# PostReinstall Toolkit for Windows 11

This PowerShell script automates post-install cleanup and setup tasks for freshly installed Windows 11 systems. It removes unnecessary bloatware, installs essential applications, configures the system UI, and performs GPU-based customization for gaming PCs.

## Features

* Removes preinstalled Microsoft and OEM (Lenovo) applications
* Detects Lenovo systems and installs Lenovo System Update
* Detects NVIDIA or AMD GPUs and:

  * Preserves Xbox services
  * Installs Xbox App, Gaming Services, Epic Games Launcher, Ubisoft Connect, and EA App (non-Lenovo PCs only)
* Installs commonly used applications (e.g., Chrome, Firefox, Discord, VLC, Steam)
* Sets system language to English and input/locale to Norwegian
* Applies Windows dark theme and taskbar customization
* Sets Google as default search engine in Edge and Chrome
* Disables hardware acceleration in Edge and Chrome
* Generates a full execution log on the desktop

## Requirements

* Windows 11
* Administrator privileges
* PowerShell 5.1 or newer

## Usage

1. Open PowerShell as Administrator.

2. Optionally bypass execution policy temporarily (if needed):

   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope Process -Force
   ```

3. Run the script:

   ```powershell
   .\PostReinstall.ps1
   ```

4. Follow the prompts and wait for the operations to complete. A log file will be saved to your desktop.

## Notes

* The script uses Winget to install software. Ensure Winget is available and up-to-date.
* The script detects GPU manufacturer and adjusts behavior accordingly.
* Some changes (like language or theme) may require a sign-out or reboot to take full effect.
* Spotify may fail to install due to elevation context. This is known behavior and safe to ignore.

## Disclaimer

Use at your own risk. Always back up your data and review the script contents before execution. This script makes changes to system settings and removes applications which may affect your workflow.
