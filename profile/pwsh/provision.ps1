if (!$IsWindows) {
    Write-Warning "Obsolete powershell version or host is not Windows machine"
    exit;
}

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
if (!$isAdmin) {
    Write-Warning "console not in admin"
    exit;
}

if(! (where.exe /Q choco)) {
    Write-Warning "choco not installed. Go to chocolatey website and install: https://chocolatey.org/"
    exit;
}

$profilePwshPath = "profile/pwsh/profile.ps1"
$profileUrl = "https://raw.githubusercontent.com/ibiernacki/miscellaneous/main/$profilePwshPath"
$profilePath = "$HOME/.profile"
$profilePwshPath = "$profilePath/$profilePwshPath"


New-Item -ItemType Directory -Force -Path "$profilePwshPath"
Invoke-RestMethod  $profileUrl -OutFile "$profilePwshPath"

& $profilePwshPath
