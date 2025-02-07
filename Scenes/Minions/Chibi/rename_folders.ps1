# Set the root directory to start the recursive search
$rootDir = "."  # Change this to your starting directory

# Get all directories recursively
$directories = Get-ChildItem -Path $rootDir -Recurse -Directory

# Loop through each directory
foreach ($dir in $directories) {
    # Check if the directory name is "Idle Blinking"
    if ($dir.Name -eq "Idle Blinking") {
        # Construct the new folder path
        $newDirPath = Join-Path -Path $dir.Parent.FullName -ChildPath "Blinking"
        
        # Rename the folder
        Rename-Item -Path $dir.FullName -NewName $newDirPath
        Write-Host "Renamed '$($dir.FullName)' to '$newDirPath'"
    }
}
