# Store current working directory (should be 'D:\repos\portfolio\masterPortfolio')
$currentDir = Get-Location
$reactAppPath = $currentDir
$portfolioDir = Split-Path $currentDir -Parent  # Get parent directory (D:\repos\portfolio)
$ghPagesRepoPath = Join-Path $portfolioDir "thaiquangquy.github.io"

# Build React App
Write-Host "Building React app..."
# Already in the correct directory ($reactAppPath)
npm install
npm run build

# Clean up old files in GitHub Pages repo
Write-Host "Cleaning old files in GitHub Pages repo..."

# Check if GitHub Pages repo exists
if (-not (Test-Path $ghPagesRepoPath)) {
  Write-Error "GitHub Pages repository not found at: $ghPagesRepoPath"
  Write-Host "Please make sure the thaiquangquy.github.io repository is cloned to the portfolio directory."
  exit 1
}

Set-Location $ghPagesRepoPath
Get-ChildItem -Exclude .git, .github, README.md, CNAME | Remove-Item -Recurse -Force

# Copy new build files
Write-Host "Copying new build files..."
Copy-Item "$reactAppPath\build\*" $ghPagesRepoPath -Recurse -Force

# Get the first 6 characters of the current commit hash from masterPortfolio
Set-Location $reactAppPath
$commitHash = (git rev-parse --short=6 HEAD).Trim()
Write-Host "Current commit hash (first 6 chars): $commitHash"

# Commit and push
Write-Host "Committing and pushing changes..."
Set-Location $ghPagesRepoPath
git add .
git commit -m "Deploy new version from masterPortfolio [$commitHash]"
git push origin main  # Change 'main' if your branch is different

Write-Host "Deployment complete! Visit: https://thaiquangquy.github.io"