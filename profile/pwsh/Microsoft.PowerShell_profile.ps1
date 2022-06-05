$newProfile = "$HOME/.profile/profile/pwsh/profile.ps1"
Write-Host -ForegroundColor DarkGray "changing `$PROFILE from $PROFILE to $newProfile"
$PROFILE = $newProfile
& $newProfile