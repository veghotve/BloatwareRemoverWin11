# BloatwareRemoverWin11
BloatwareRemoverWin11 is a PowerShell script that removes bloatware from Windows 11. It uses the Get-AppxPackage and Remove-AppxPackage cmdlets to uninstall the specified applications.

# Usage
To use the script, follow these steps:

1. Open PowerShell with administrator privileges. You can do this by searching for "PowerShell" in the Start menu, right-clicking the Windows PowerShell result, and selecting "Run as administrator".

2. Navigate to the folder that contains the script. You can do this using the cd command followed by the folder path (e.g. cd C:\Users\JohnDoe\Documents).

3. Type the name of the script file (e.g. .\remove-bloatware.ps1) and press Enter.

4. The script will start removing the specified apps. You will see a list of the apps that have been removed in the PowerShell window, as well as a message indicating that a log file has been saved to the desktop.

Note that this script modifies the Windows operating system, so use at your own risk and make sure to backup your data before proceeding. Removing certain applications may affect the functionality of other applications. Be sure to review the list of bloatware and make sure you are comfortable with what will be removed.

# Releases
## Release v1.0.0 - Initial Release
This is the initial release of BloatwareRemoverWin11. It includes a list of bloatware that can be customized by editing the $bloatware array in the script. It also includes logging functionality that writes a log file to the current user's desktop with the name bloatware-removal.log. The log file records the names of the apps that have been removed.

1. To download and use the release, follow these steps:

2. Go to the Releases page of the repository.

3. Click on the release title to view the release details.

4. Download the attached files or the source code.

5. Extract the files to a folder on your computer.

6. Open PowerShell with administrator privileges and navigate to the folder containing the script.

7. Type the name of the script file (e.g. .\remove-bloatware.ps1) and press Enter.
The script will start removing the specified apps. You will see a list of the apps that have been removed in the PowerShell window, as well as a message indicating that a log file has been saved to the desktop.

We hope you find this script useful! If you encounter any issues or have any feedback, please feel free to open an issue on the GitHub repository.
