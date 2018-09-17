$destination = "C:\Tasks"

Get-ChildItem -Exclude "deploy-tasks.ps1" | Copy-Item -Include $_ -Destination $destination 


