# Define the path of the folder containing the PNG files
$folderPath = "."

# Define the text to remove from the file names
$textToRemove = "PC Computer - Ragnarok Online - "

# Get all PNG files in the folder
$pngFiles = Get-ChildItem -Path $folderPath -Filter "*.png"

# Loop through each file and rename it
foreach ($file in $pngFiles) {
    # Check if the file name contains the text to remove
    if ($file.Name -match [regex]::Escape($textToRemove)) {
        # Construct the new name by replacing the text to remove with an empty string
        $newName = $file.Name -replace [regex]::Escape($textToRemove), ""
        
        # Construct the full path for the new file name
        $newPath = Join-Path -Path $file.DirectoryName -ChildPath $newName
        
        # Rename the file
        Rename-Item -Path $file.FullName -NewName $newPath
        Write-Host "Renamed $($file.Name) to $newName"
    }
}
