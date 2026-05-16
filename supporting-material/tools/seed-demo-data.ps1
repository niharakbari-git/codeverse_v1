$ErrorActionPreference = "Stop"

Write-Host "Starting CodeVerse fresh demo reset + seeding..."
Write-Host "This will clear current app data and seed scenario-ready demo users, hackathons, teams, and applications."

mvn spring-boot:run "-Dspring-boot.run.arguments=--app.seed-demo-data=true --spring.main.web-application-type=none"

Write-Host "Seeding command finished."
Write-Host "Default password for all seeded users: 00000000"
Write-Host "Participant emails: part1@gmail.com to part5@gmail.com"
Write-Host "Organizer emails: org1@gmail.com to org5@gmail.com"
Write-Host "Judge emails: judge1@gmail.com to judge5@gmail.com"
