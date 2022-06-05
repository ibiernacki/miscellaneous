# Provisioning scripts
To provision via powershell run:
``` 
> Set-ExecutionPolicy RemoteSigned -Scope CurrentUser # Optional: Needed to run a remote script the first time
> $provisionScript = irm https://raw.githubusercontent.com/ibiernacki/miscellaneous/main/profile/pwsh/provision.ps1
> $provisionScript
```
