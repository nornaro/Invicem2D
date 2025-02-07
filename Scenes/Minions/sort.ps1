# Define paths
$sourceDir = ".\PixelArt"        # Path to the PixelArt directory
$targetDir = ".\PixelArt2"       # Path to the PixelArt2 directory
$targetDir3 = ".\PixelArt3"      # Path to the PixelArt3 directory
$patterns = @("Dead*.png", "Hurt*.png", "Idle*.png", "Special*.png", "Walk*.png")

# Check if PixelArt2 and PixelArt3 folders exist, if not, create them
if (-not (Test-Path $targetDir)) {
    New-Item -Path $targetDir -ItemType Directory
}

if (-not (Test-Path $targetDir3)) {
    New-Item -Path $targetDir3 -ItemType Directory
}

# Get all subfolders in PixelArt (excluding PixelArt2 and PixelArt3)
$subFolders = Get-ChildItem -Path $sourceDir -Directory | Where-Object { $_.Name -ne "PixelArt2" -and $_.Name -ne "PixelArt3" }

# Process folders in PixelArt
foreach ($folder in $subFolders) {
    $folderPath = $folder.FullName
    $missingFiles = 0

    # Check if each required file pattern exists in the folder
    foreach ($pattern in $patterns) {
        $matchingFiles = Get-ChildItem -Path $folderPath -Filter $pattern -File
        if ($matchingFiles.Count -eq 0) {
            $missingFiles++
        }
    }

    # If any required file is missing, move the folder to PixelArt2
    if ($missingFiles -gt 0) {
        $destination = Join-Path $targetDir $folder.Name
        Write-Host "Moving folder '$($folder.Name)' to PixelArt2 because it is missing $missingFiles file(s)."
        Move-Item -Path $folderPath -Destination $destination
    }
}

# Process folders in PixelArt2 and move to PixelArt3 if exactly 1 file is missing
$subFoldersPixelArt2 = Get-ChildItem -Path $targetDir -Directory

foreach ($folder in $subFoldersPixelArt2) {
    $folderPath = $folder.FullName
    $missingFiles = 0

    # Check if each required file pattern exists in the folder
    foreach ($pattern in $patterns) {
        $matchingFiles = Get-ChildItem -Path $folderPath -Filter $pattern -File
        if ($matchingFiles.Count -eq 0) {
            $missingFiles++
        }
    }

    # If exactly 1 required file is missing, move the folder to PixelArt3
    if ($missingFiles -eq 1) {
        $destination = Join-Path $targetDir3 $folder.Name
        Write-Host "Moving folder '$($folder.Name)' from PixelArt2 to PixelArt3 because it is missing exactly 1 file."
        Move-Item -Path $folderPath -Destination $destination
    }
}
