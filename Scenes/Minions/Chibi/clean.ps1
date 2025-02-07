# Set the root directory to start searching for the folders
$rootDir = "."  # Change this to the directory where you want to search

# List of folders to exclude from deletion
$excludeFolders = @("Blinking", "Dying", "Hurt", "Idle", "Walking")

# Get all directories in the root directory (recursively)
$directories = Get-ChildItem -Path $rootDir -Recurse -Directory

# Loop through each directory
foreach ($dir in $directories) {
    $Sequences = Get-ChildItem -Path $dir.FullName -Directory | Where-Object { $_.Name -eq "PNG Sequences" }
    if ($Sequences) {
        $subDirectories = Get-ChildItem -Path $Sequences.FullName -Directory

        # Loop through each subdirectory and delete the ones not in the exclusion list
        foreach ($subDir in $subDirectories) {
            if ($excludeFolders -notcontains $subDir.Name) {
                Remove-Item -Path $subDir.FullName -Recurse -Force
			}
        }
    }
}
