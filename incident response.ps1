do {
    # Welcome message
    Write-Host 'Blue Team Script: User Accounts, Local Groups, Processes, and File Management'

    # Menu options
    Write-Host '[1] View User Accounts'
    Write-Host '[2] Manage Local Groups'
    Write-Host '[3] View Processes'
    Write-Host '[4] View Startup Applications'
    Write-Host '[5] View Files by Type'

    # Get user input
    $choice = Read-Host "Enter your choice (1, 2, 3, 4, 5, or 'exit' to quit): "

    # Process user choice
    switch ($choice) {
        "1" {
            # Get user accounts and format output
            Get-LocalUser | Select-Object Name, Enabled, Description | Format-Table Name, Enabled, Description -AutoSize
        }
        "2" {
            # Manage Local Groups options
            Write-Host '** Manage Local Groups **'
            Write-Host '[2.1] List Available Local Groups'
            Write-Host '[2.2] View Members of a Local Group'

            $groupChoice = Read-Host "Enter your choice (2.1, 2.2, or 'exit' to quit): "

            switch ($groupChoice) {
                "2.1" {
                    # List all local groups
                    $localGroups = Get-LocalGroup
                    Write-Host "Available Local Groups:"
                    $localGroups | Format-Table Name -AutoSize
                }
                "2.2" {
                    # Ask user to choose a group
                    Write-Host "Enter the name of the local group: "
                    $groupName = Read-Host

                    # Validate group existence (optional)
                    if (!(Get-LocalGroup -Name $groupName)) {
                        Write-Error "Invalid group name. Please choose from the list provided (if you listed them previously)."
                        break
                    }

                    # Use net localgroup to list members
                    Write-Host "Members of group '$groupName':"
                    net localgroup $groupName
                }
                "exit" {
                    # Exit inner loop for Manage Local Groups
                    Write-Host "Exiting Manage Local Groups..."
                    break
                }
                default {
                    Write-Error "Invalid choice. Please enter 2.1, 2.2, or 'exit'."
                }
            }
        }
        "3" {
            # View Processes options
            Write-Host '** View Processes **'
            Write-Host '[3.1] View Processes with Tasklist'
            Write-Host '[3.2] Get Path of a Process by PID'

            $processChoice = Read-Host "Enter your choice (3.1, 3.2, or 'exit' to quit): "

            switch ($processChoice) {
                "3.1" {
                    # View processes with tasklist
                    tasklist
                }
                "3.2" {
                    # Get path of a process by PID
                    $processPID = Read-Host "Enter the PID of the process: "
                    wmic process where "ProcessID='$processPID'" get Commandline
                }
                "exit" {
                    # Exit inner loop for View Processes
                    Write-Host "Exiting View Processes..."
                    break
                }
                default {
                    Write-Error "Invalid choice. Please enter 3.1, 3.2, or 'exit'."
                }
            }
        }
        "4" {
            # View Startup Applications
            Write-Host '** View Startup Applications **'
            Write-Host 'Make sure to run PowerShell as an administrator.'
            Write-Host 'Type the following command: wmic startup get caption,command'
            Read-Host "Press Enter to continue..."
            wmic startup get caption,command
        }
        "5" {
    # Prompt user to choose the type of file to search for
    $fileType = Read-Host "Enter the file type to search for (exe, ps1, msi, bat, zip): "

    # Validate the file type
    if ($fileType -eq "exe" -or $fileType -eq "ps1" -or $fileType -eq "msi" -or $fileType -eq "bat" -or $fileType -eq "zip") {
        # Prompt user for the path to search for files
        $searchPath = Read-Host "Enter the path to search for $fileType files (e.g., C:\): "

        # Validate the path
        if (Test-Path $searchPath) {
            # View files with their paths
            Write-Host "** View $fileType Files in $searchPath **"
            Write-Host "Type the following command to locate $fileType files in ${searchPath}:"
            Write-Host "forfiles /P $searchPath /S /M *.$fileType /C `"cmd /c echo @path`""
            Read-Host "Press Enter to continue..."
            forfiles /P $searchPath /S /M *.$fileType /C "cmd /c echo @path"
        } else {
            Write-Error "Invalid path. Please enter a valid path."
        }
    } else {
        Write-Error "Invalid file type. Please enter 'exe', 'msi', 'bat' or 'zip'."
    }
}
        "exit" {
            # Exit outer loop for entire script
            Write-Host "Exiting script..."
            break
        }
        default {
            Write-Error "Invalid choice. Please enter 1, 2, 3, 4, 5, or 'exit'."
        }
    }
} while ($choice -ne "exit") # Loop continues until user enters "exit"

Write-Host "Script execution completed."
