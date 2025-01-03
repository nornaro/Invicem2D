# Set the base folder
$baseFolder = "g:\Godot\Invicem2D\Scenes\Building\"

# Ensure ImageMagick is installed and in PATH
if (-not (Get-Command "magick" -ErrorAction SilentlyContinue)) {
    Write-Host "ImageMagick is not installed or not in PATH. Please install it and add to PATH." -ForegroundColor Red
    exit
}

# Resize function
function Resize-PNG {
    param (
        [string]$file
    )

    # Output the resized file in the same location
    $outputFile = $file

    # Use ImageMagick to resize
    magick convert "$file" -resize 1280x "$outputFile"
    Write-Host "Resized: $file"
}

# Get all PNG files in the folder and its subfolders
$pngFiles = Get-ChildItem -Path $baseFolder -Recurse -Include *.png

# Process each PNG file
foreach ($pngFile in $pngFiles) {
    Resize-PNG -file $pngFile.FullName
}

Write-Host "All PNG files have been resized to 1280 pixels wide."
