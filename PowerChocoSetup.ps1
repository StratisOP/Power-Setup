#Install Chocolatey
Set-ExecutionPolicy Unrestricted -Scope Process -Force; Invoke-Expression `
((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
 
#Install programs
$programs = New-Object -TypeName System.Collections.ArrayList
$programs.AddRange(@(
        "vlc",
        "googlechrome",
        "firefox",
        "winrar",
        #"7zip",
        #"adobereader",
        #"anydesk.install",
        "zoom"
    )
)
foreach ($program in $programs) {
    choco install $program -y
}
#Uninstall Chocolatey
Remove-Item -Recurse -Force "$env:ChocolateyInstall"
[System.Text.RegularExpressions.Regex]::Replace([Microsoft.Win32.Registry]::CurrentUser.OpenSubKey('Environment').GetValue('PATH', '', [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames).ToString(), [System.Text.RegularExpressions.Regex]::Escape("$env:ChocolateyInstall\bin") + '(?>;)?', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase) | ForEach-Object { [System.Environment]::SetEnvironmentVariable('PATH', $_, 'User') }
[System.Text.RegularExpressions.Regex]::Replace([Microsoft.Win32.Registry]::LocalMachine.OpenSubKey('SYSTEM\CurrentControlSet\Control\Session Manager\Environment\').GetValue('PATH', '', [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames).ToString(), [System.Text.RegularExpressions.Regex]::Escape("$env:ChocolateyInstall\bin") + '(?>;)?', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase) | ForEach-Object { [System.Environment]::SetEnvironmentVariable('PATH', $_, 'Machine') }
#Clear Temp in Appdata
Remove-Item -Path $env:LOCALAPPDATA\Temp\* -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path $env:LOCALAPPDATA\NuGet -Recurse -Force -ErrorAction SilentlyContinue
Stop-Process -processname explorer -ErrorAction SilentlyContinue