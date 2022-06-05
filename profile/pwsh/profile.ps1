$profileName = "ibiernacki"
$profileGithubUrl = "https://raw.githubusercontent.com/ibiernacki/miscellaneous/main/"


$profilePath = "$HOME/.profile"
$workspace = "shared" #available options: "dev", "shared", "qa"
$code = "$HOME/code"
$ohMyPoshTheme = "default"
$ohmyposhConfigPath = "$profilePath/profile/oh-my-posh/$ohMyPoshTheme.json"


#set up global variables (available in whole system)
$globalEnvVariables = @{
    dev       = "$HOME/dev" #path to code repos
    workspace = "$workspace";
} #usage: Write-Host $env:workspace


if ($IsWindows) {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    if (!$isAdmin) {
        Write-Warning "console not in admin"
    }
}

#todo: this section should be be stateless
if (!([Environment]::GetEnvironmentVariable("provisioned", 'Machine') -eq "$profileName")) {
    
    if(!$isAdmin) {
        Write-Warning "console not in admin (launch in admin to provision)"
        exit;
    }

    Write-Warning "Provisioning..."
    Install-Module -Name Terminal-Icons -Repository PSGallery -Force
    Install-Module PSReadLine -AllowPrerelease -Force -AcceptLicense

    $index = 0
    $globalEnvVariables.Keys | ForEach-Object {
        $key = $_ 
        $globalEnvVariables.Values | Select-Object -First 1 -Skip $index | ForEach-Object {
            [Environment]::SetEnvironmentVariable($key, $_ , 'Machine')
        }
        $index ++
        }
    
    New-Item -ItemType Directory -Force -Path "$HOME/.profile/profile/oh-my-posh"
    $profileUrl = "https://raw.githubusercontent.com/ibiernacki/miscellaneous/main/profile/oh-my-posh/$ohMyPoshTheme.json"
    Invoke-RestMethod  $profileUrl -OutFile "$ohmyposhConfigPath"

    Write-Host "Provisioning completed"
    [Environment]::SetEnvironmentVariable("provisioned", $profileName, 'Machine')
}

#---

Import-Module -Name Terminal-Icons
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineKeyHandler -Chord Shift+Spacebar -Function MenuComplete

oh-my-posh --init --shell pwsh --config $ohmyposhConfigPath | Invoke-Expression


#initialize tools completion
if ($IsWindows) {
    if (where.exe /Q kubectl) { kubectl completion powershell | Out-String | Invoke-Expression }
    if (where.exe /Q istioctl) { istioctl completion powershell | Out-String | Invoke-Expression }
    if (where.exe /Q kn-admin) { kn-admin completion powershell | Out-String | Invoke-Expression }
    if (where.exe /Q kn-quickstart) { kn quickstart completion powershell | Out-String | Invoke-Expression }
    if (where.exe /Q cmctl) { cmctl completion powershell | Out-String | Invoke-Expression }

    #dotnet completion
    Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
        param($commandName, $wordToComplete, $cursorPosition)
        dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
    }
}

$workspaces = @{
    dev = @{
        name = "private"; 
        context = "minikube" #fetch using kubectl config get-contexts
    };
    shared = @{
        name = "shared";
        context = "<context-name>"; #fetch using kubectl config get-contexts
        
    };
    qa = @{
        name = "qa";
        context = "<context-name>"
    };
}
