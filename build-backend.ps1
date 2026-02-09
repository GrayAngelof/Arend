# build-backend.ps1
Write-Host "Building Markoff Backend Docker image..." -ForegroundColor Cyan
docker build -f docker/Dockerfile.backend -t markoff-backend:dev .
Write-Host "✅ Build completed!" -ForegroundColor Green


