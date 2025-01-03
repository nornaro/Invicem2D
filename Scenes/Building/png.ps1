# Define the starting folder
$startFolder = "."

# Function to recursively process each folder
function Process-Folder {
    param (
        [string]$currentFolder
    )

    # Get all subfolders
    $subFolders = Get-ChildItem -Path $currentFolder -Directory

    foreach ($subFolder in $subFolders) {
        # If the folder is named 'Styles'
        if ($subFolder.Name -eq "Styles") {
            # Get the parent folder's name
            $parentFolder = (Get-Item $subFolder.FullName).Parent.Name

            # Get all PNG files in the 'Styles' folder and its subfolders
            $pngFiles = Get-ChildItem -Path $subFolder.FullName -Recurse -Filter "*.png"

            foreach ($file in $pngFiles) {
                # Check if the file name starts with the parent folder's name
                if (-not ($file.BaseName -like "$parentFolder*")) {
                    # Delete the file
                    Remove-Item -Path $file.FullName -Force
                    Write-Host "Deleted: $($file.FullName)"
                }
            }
        } else {
            # Recursively process other subfolders
            Process-Folder -currentFolder $subFolder.FullName
        }
    }
}

# Start processing the folder
Process-Folder -currentFolder $startFolder
