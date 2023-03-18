# BloatwareWin11
PowerShell script that removes bloatware in Windows 11. 

# Overview
This PowerShell script removes bloatware from Windows 11. It uses the Get-AppxPackage and Remove-AppxPackage cmdlets to uninstall the specified applications. The list of bloatware can be customized by editing the $bloatware array in the script.

The script also writes a log file that records the names of the apps that have been removed. The log file is saved to the current user's desktop with the name bloatware-removal.log.

# How to Run
To run the script, follow these steps:

Open PowerShell with administrator privileges. You can do this by searching for "PowerShell" in the Start menu, right-clicking the Windows PowerShell result, and selecting "Run as administrator".

Navigate to the folder that contains the script. You can do this using the cd command followed by the folder path (e.g. cd C:\Users\JohnDoe\Documents).

Type the name of the script file (e.g. .\remove-bloatware.ps1) and press Enter.

The script will start removing the specified apps. You will see a list of the apps that have been removed in the PowerShell window, as well as a message indicating that a log file has been saved to the desktop.

# Customization
To customize the list of bloatware, you can edit the $bloatware array at the beginning of the script. Add or remove the app names as desired. You can also modify the log file path by changing the value of the $logPath variable.

# Notes
- This script modifies the Windows operating system. While it has been tested and is safe to use, there is always a risk of unintended consequences. Use at your own risk and make sure to backup your data before proceeding.
- Removing certain applications may affect the functionality of other applications. Be sure to review the list of bloatware and make sure you are comfortable with what will be removed.
- This script requires administrator privileges to run.
- The script has been tested on Windows 11 but may work on other versions of Windows as well.
