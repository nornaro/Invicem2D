$rootFolder = "g:\Godot\demo\Invicem2D\addons\gd_profiler\textures\"

# Get all .tres files recursively
Get-ChildItem -Path $rootFolder -Recurse -Filter "*.tres" | ForEach-Object {
    # Read the file content
    $content = Get-Content $_.FullName -Raw

    # Replace .png with .webp
    $updatedContent = $content -replace '\.png', '.webp'

    # Write the updated content back to the file
    Set-Content -Path $_.FullName -Value $updatedContent
}
