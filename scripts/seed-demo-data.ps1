$ErrorActionPreference = "Stop"

Write-Host "Starting CodeVerse demo data seeding..."
Write-Host "This will create/update test users and ensure 10 demo hackathons."

mvn spring-boot:run "-Dspring-boot.run.arguments=--app.seed-demo-data=true --spring.main.web-application-type=none"

Write-Host "Seeding command finished."
Write-Host "Default password for all seeded users: 00000000"
