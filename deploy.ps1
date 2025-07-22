# Store current working directory (assumes it's 'D:\repos\portfolio')
$rootDir = Get-Location
$reactAppPath = Join-Path $rootDir "masterPortfolio"
$ghPagesRepoPath = Join-Path $rootDir "thaiquangquy.github.io"

# Build React App
Write-Host "Building React app..."
Set-Location $reactAppPath
npm install
npm run build

# Clean up old files in GitHub Pages repo
Write-Host "Cleaning old files in GitHub Pages repo..."
Set-Location $ghPagesRepoPath
Get-ChildItem -Exclude .git, .github, README.md, CNAME | Remove-Item -Recurse -Force

# Copy new build files
Write-Host "Copying new build files..."
Copy-Item "$reactAppPath\build\*" $ghPagesRepoPath -Recurse -Force

# Commit and push
Write-Host "Committing and pushing changes..."
git add .
git commit -m "Deploy new version from masterPortfolio"
git push origin main  # Change 'main' if your branch is different

Write-Host "Deployment complete! Visit: https://thaiquangquy.github.io"