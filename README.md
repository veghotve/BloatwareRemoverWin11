# WindowsCleanupAndSetup

**WindowsCleanupAndSetup** is a PowerShell script for automating post-installation cleanup and configuration of Windows 11. It removes unwanted software, applies recommended system settings, and installs essential tools. It also adapts its behavior based on whether the system is a Lenovo device or a gaming PC with an NVIDIA or AMD GPU.

## Features

* Removes Microsoft/UWP bloatware
* Cleans up Lenovo-specific OEM software (if detected)
* Installs Lenovo System Update silently
* Detects NVIDIA/AMD GPUs and installs:

  * Xbox app and Gaming Services
  * Epic Games Launcher, Ubisoft Connect, EA App (only on non-OEM PCs)
* Installs common applications using Winget:

  * Chrome, Firefox, Steam, VLC, Discord, 7-Zip, Notepad++, KeePassXC, Visual Studio Code, PuTTY, PowerToys, Spotify, PowerShell
* Sets Windows display language to English, with Norwegian keyboard layout and time/date format
* Applies dark Windows theme
* Customizes taskbar:

  * Removes Search Box, Task View, Widgets
* Sets Google as default search engine in Edge and Chrome
* Disables hardware acceleration in Edge and Chrome
* Outputs a detailed log to the desktop

## Usage

1. **Open PowerShell as Administrator**

2. **If script execution is blocked**, run this command first:

   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
   ```

3. **Run the script**:

   ```powershell
   .\WindowsCleanupAndSetup.ps1
   ```

4. **Log File**:
   The script generates a log at:

   ```
   C:\Users\<YourUsername>\Desktop\PostInstall-Cleanup.log
   ```

## Notes

* Xbox/Game Services and other gaming-related apps are only installed if a compatible GPU is detected and the device is not OEM (e.g., not Lenovo).
* Winget must be available on the system.
* Make sure to review and adjust the script for your needs before running it in production.

## Disclaimer

This script makes system-level changes. Use it at your own risk. Always test in a controlled environment first.
