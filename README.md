# Provisioning scripts
To provision via `powershell` run:
``` 
> Set-ExecutionPolicy Unrestricted -Scope CurrentUser # Optional: Needed to run a remote script the first time
> (irm https://github.com/ibiernacki/miscellaneous/blob/main/profile/pwsh/provision.ps1) >> $PROFILE
```
