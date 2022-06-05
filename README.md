# Provisioning scripts
To provision via powershell run:
``` 
> Set-ExecutionPolicy Unrestricted -Scope CurrentUser # Optional: Needed to run a remote script the first time
> (irm https://raw.githubusercontent.com/ibiernacki/miscellaneous/main/profile/pwsh/provision.ps1) >> $PROFILE
```
