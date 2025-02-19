$folderPath = "g:\Godot\demo\fix\Scenes\Minions\"
$height = 900

# Clean up any previously resized files with 'resized_' prefix
$previousResizedFiles = Get-ChildItem -Path $folderPath -Filter "resized_*.webp" -Recurse
foreach ($file in $previousResizedFiles) {
    Remove-Item $file.FullName -Force
}

# Resize the original files to 900px height, keeping the original filenames
$webpFiles = Get-ChildItem -Path $folderPath -Filter *.webp -Recurse
foreach ($file in $webpFiles) {
    magick $file.FullName -resize x$height $file.FullName
}
