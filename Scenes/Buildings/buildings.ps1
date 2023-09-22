# Define the directory containing the .png files
$pngDirectory = ".\Building"

# Define the directory where the .gd files will be created
$gdDirectory = "."

# Get a list of all .png files in the specified directory
$pngFiles = Get-ChildItem -Path $pngDirectory -Filter *.png

# Iterate through each .png file
foreach ($pngFile in $pngFiles) {
    # Define the name and path for the .gd file
    $gdFileName = $pngFile.BaseName + ".gd"
    $gdFilePath = Join-Path -Path $gdDirectory -ChildPath $gdFileName
    
    # Check if the .gd file already exists
    if (-Not (Test-Path -Path $gdFilePath)) {
        # If the .gd file does not exist, create it with the specified content
        $gdContent = @"
extends Node

@export var Data = {}

func _ready():
    pass
"@
        $gdContent | Out-File -FilePath $gdFilePath -Encoding UTF8
        Write-Output "Created $gdFilePath"
    } else {
        Write-Output "$gdFilePath already exists"
    }
}
