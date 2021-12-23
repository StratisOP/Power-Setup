param([switch]$Elevated)
function IsAdmin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
if ((IsAdmin) -eq $false) {
    if ($elevated) {}
    else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
}
# Hide console
$SW_HIDE, $SW_SHOW = 0, 5
$TypeDef = '[DllImport("User32.dll")]public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);'
Add-Type -MemberDefinition $TypeDef -Namespace Win32 -Name Functions
$hWnd = (Get-Process -Id $PID).MainWindowHandle
$Null = [Win32.Functions]::ShowWindow($hWnd, $SW_HIDE)
function WinLangSetup {
    #Set Language, region, and keyboard languages
    Set-Culture en-US
    Set-WinUILanguageOverride -Language en-US
    Set-WinUserLanguageList en-US, el-GR -Force
    Set-WinHomeLocation -GeoId 98
    Set-WinSystemLocale -SystemLocale el-GR #On next boot
}
function WinNetSetup {
    #Enable firewall rule for Remote Desktop - User Mode (TCP & UDP)
    Get-NetFirewallRule -DisplayName "Remote Desktop - User*" | Set-NetFirewallRule -Enabled true

    #Enable firewall rule for Remote Desktop - User Mode (TCP & UDP) (Greek Firewall Rules)
    Get-NetFirewallRule -DisplayName "Απομακρυσμένη επιφάνεια εργασίας - Λειτουργία χρήστη*" | Set-NetFirewallRule -Enabled true
}
function WinProxySetup {
    #Disable Automatically Detect proxy settings
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" AutoDetect 0
}
function WinTimeSetup {
    #Set time automatically
    Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters Type NTP
    #Set timezone automatically 
    Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate Start 3
}
function WinExplorerSetup {
    $WinExpPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer"
    $WinExpPathAdv = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    $PolWinExp = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
    #Show Frequent files
    Set-ItemProperty -Path $WinExpPath ShowFrequent 0
    #Show Recent files
    Set-ItemProperty -Path $WinExpPath ShowRecent 0 
    #Show File Extensions
    Set-ItemProperty -Path $WinExpPathAdv HideFileExt 0
    #Hide Cortana button
    Set-ItemProperty -Path $WinExpPathAdv ShowCortanaButton 0
    #Hide Task View button
    Set-ItemProperty -Path $WinExpPathAdv ShowTaskViewButton 0
    #Open file explorer to This PC
    Set-ItemProperty -Path $WinExpPathAdv LaunchTo 1
    #Disable app start tracking
    Set-ItemProperty -Path $WinExpPathAdv Start_TrackProgs 0
    #Disable Edge desktop shortcut on new user accounts
    Set-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer DisableEdgeDesktopShortcutCreation 1
    #Disable tips, tricks and suggestions
    $path = Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent
    if (-not($path)) {
        New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\ -Name CloudContent | Out-Null
    }
    Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent DisableSoftLanding 1
    #Hide search box on taskbar
    Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search SearchboxTaskbarMode 1
    #Unpin Edge from tasbkar
    $path = Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband
    if (($path)) {
        Remove-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Recurse -Force
    }
    #Disable People button on taskbar
    $path = Test-Path -Path HKCU:\Software\Policies\Microsoft\Windows\Explorer
    if (-not($path)) {
        New-Item -Path HKCU:\Software\Policies\Microsoft\Windows\ -Name Explorer | Out-Null
    }
    Set-ItemProperty -Path HKCU:\Software\Policies\Microsoft\Windows\Explorer HidePeopleBar 1
    $path = Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer
    if (-not($path)) {
        New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\ -Name Explorer | Out-Null
    }
    Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer HidePeopleBar 1

    #Hide recently added from start
    Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer HideRecentlyAddedApps 1

    #Remove 'news and interests' button from taskbar
    $path = Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds"
    if (-not($path)) {
        New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\ -Name "Windows Feeds" | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" EnableFeeds 0

    #Disable Bing Search from start
    $path = Test-Path -Path $PolWinExp
    if (-not($path)) {
        New-Item -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows -Name Explorer | Out-Null
    }
    Set-ItemProperty -Path $PolWinExp -Name DisableSearchBoxSuggestions 1

    #Set taskbar layout
    $taskbar = @'
<LayoutModificationTemplate
xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification"
xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout"
xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout"
xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout"
Version="1">
<DefaultLayoutOverride>
<StartLayoutCollection>
<defaultlayout:StartLayout GroupCellWidth="6" xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout">
<start:Group Name="Windows Server" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout">
  <start:DesktopApplicationTile Size="2x2" Column="2" Row="2" DesktopApplicationLinkPath="" />
</start:Group>
</defaultlayout:StartLayout>
</StartLayoutCollection>
</DefaultLayoutOverride>
<CustomTaskbarLayoutCollection PinListPlacement="Replace">
<defaultlayout:TaskbarLayout>
 <taskbar:TaskbarPinList>
    <taskbar:DesktopApp DesktopApplicationLinkPath="%APPDATA%\Microsoft\Windows\Start Menu\Programs\System Tools\File Explorer.lnk" />
    <taskbar:DesktopApp DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk" /> 
    <taskbar:DesktopApp DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Firefox.lnk" /> 
    <taskbar:DesktopApp DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Outlook.lnk" /> 
    <taskbar:DesktopApp DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Word.lnk" /> 
    <taskbar:DesktopApp DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Excel.lnk" /> 
</taskbar:TaskbarPinList>
</defaultlayout:TaskbarLayout>
</CustomTaskbarLayoutCollection>
</LayoutModificationTemplate>
'@
    $taskbar | Out-File $env:temp\Layout.xml
    Import-StartLayout -LayoutPath "$env:temp\Layout.xml" -MountPath c:\
    Stop-Process -processname explorer -ErrorAction SilentlyContinue
}
function WinPowerSetup {
    #Sets active power plan to High Performance
    powercfg -setactive 8C5E7fda-e8bf-4a96-9a85-a6e23a8c635c
    #Disables Hibernation
    powercfg -hibernate off
}
function PowerDisplayTimer {
    #Changes the value of "Turn off the display:"
    powercfg -change -monitor-timeout-ac 0
}
function PowerComputerTimer {
    #Changes the value of "Put the computer to sleep:"
    powercfg -change -standby-timeout-ac 0
}
function WinAppRemove {
    #Disable OEM apps from reinstalling on current user
    $cdm = @(
        "ContentDeliveryAllowed"
        "FeatureManagementEnabled"
        "OemPreInstalledAppsEnabled"
        "PreInstalledAppsEnabled"
        "PreInstalledAppsEverEnabled"
        "SilentInstalledAppsEnabled"
        "SubscribedContent-314559Enabled"
        "SubscribedContent-338387Enabled"
        "SubscribedContent-338388Enabled"
        "SubscribedContent-338389Enabled"
        "SubscribedContent-338393Enabled"
        "SubscribedContentEnabled"
        "SystemPaneSuggestionsEnabled"
    )
    $path = Test-Path -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    if (-not($path)) {
        New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ -Name "ContentDeliveryManager" | Out-Null
    }
    foreach ($key in $cdm) {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" $key 0
    }
    #Remove Built in Windows apps
    $Apps = New-Object -TypeName System.Collections.ArrayList
    $Apps.AddRange(@(
            "Microsoft.YourPhone",
            "Microsoft.WindowsAlarms",
            "Microsoft.SkypeApp",
            "Microsoft.BingWeather",
            "Microsoft.GetHelp",
            "Microsoft.Getstarted",
            "Microsoft.Microsoft3DViewer",
            "Microsoft.People",
            "Microsoft.WindowsMaps",
            "Microsoft.549981C3F5F10", #Cortana
            "Microsoft.MicrosoftSolitaireCollection",
            "Microsoft.MixedReality.Portal",
            "Microsoft.WindowsFeedbackHub",
            "Microsoft.Xbox.TCUI",
            "Microsoft.XboxApp",
            "Microsoft.XboxGameOverlay",
            "Microsoft.XboxGamingOverlay",
            "Microsoft.XboxIdentityProvider",
            "Microsoft.XboxSpeechToTextOverlay",
            "Microsoft.ZuneMusic",
            "Microsoft.ZuneVideo",
            "Microsoft.Appconnector",
            "Microsoft.BingFinance",
            "Microsoft.BingNews",
            "Microsoft.BingSports",
            "Microsoft.BingTranslator",
            "Microsoft.BingWeather",
            #HP OEM
            "AD2F1837.HPInc.EnergyStar",
            "AD2F1837.HPAudioCenter ",
            "AD2F1837.HPPCHardwareDiagnosticsWindows",
            "AD2F1837.HPPrinterControl",
            "AD2F1837.HPPrivacySettings",
            "AD2F1837.HPQuickDrop",
            "AD2F1837.HPSupportAssistant",
            "AD2F1837.HPSystemEventUtility",
            "AD2F1837.myHP",
            "5A894077.McAfeeSecurity",
            "0E3921EB.sMedioTrueDVDforHP",
            "PricelinePartnerNetwork.Booking.comEMEABigsavingso",
            "C27EB4BA.DropboxOEM",
            #Non-Microsoft
            "2FE3CB00.PicsArt-PhotoStudio",
            "46928bounde.EclipseManager",
            "4DF9E0F8.Netflix",
            "613EBCEA.PolarrPhotoEditorAcademicEdition",
            "6Wunderkinder.Wunderlist",
            "7EE7776C.LinkedInforWindows",
            "89006A2E.AutodeskSketchBook",
            "9E2F88E3.Twitter",
            "A278AB0D.DisneyMagicKingdoms",
            "A278AB0D.MarchofEmpires",
            "ActiproSoftwareLLC.562882FEEB491",
            "CAF9E577.Plex"  ,
            "ClearChannelRadioDigital.iHeartRadio",
            "D52A8D61.FarmVille2CountryEscape",
            "D5EA27B7.Duolingo-LearnLanguagesforFree",
            "DB6EA5DB.CyberLinkMediaSuiteEssentials",
            "DolbyLaboratories.DolbyAccess",
            "DolbyLaboratories.DolbyAccess",
            "Drawboard.DrawboardPDF",
            "Facebook.Facebook",
            "Fitbit.FitbitCoach",
            "Flipboard.Flipboard"
            "GAMELOFTSA.Asphalt8Airborne",
            "KeeperSecurityInc.Keeper",
            "NORDCURRENT.COOKINGFEVER",
            "PandoraMediaInc.29680B314EFC2",
            "Playtika.CaesarsSlotsFreeCasino",
            "ShazamEntertainmentLtd.Shazam",
            "SlingTVLLC.SlingTV",
            "SpotifyAB.SpotifyMusic"
        )
    )
    foreach ($App in $Apps) {
        Get-AppxPackage $App | Remove-AppxPackage
    }
    # Prevents Suggested Applications returning
    $path = Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent
    if (-not($path)) {
        New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\ -Name CloudContent | Out-Null
    }
    $path = Test-Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\LastPass.lnk"
    if ($path) {
        Remove-Item "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\LastPass.lnk" -Force
    }
    $path = Test-Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Free Trials.lnk"
    if ($path) {
        Remove-Item "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Free Trials.lnk" -Force
    }
}
function ChocoInstall {
    #Install Chocolatey
    Set-ExecutionPolicy Unrestricted -Scope Process -Force; Invoke-Expression `
    ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}
function ChocoRemove {
    #Uninstall Chocolatey
    Remove-Item -Recurse -Force "$env:ChocolateyInstall"
    [System.Text.RegularExpressions.Regex]::Replace([Microsoft.Win32.Registry]::CurrentUser.OpenSubKey('Environment').GetValue('PATH', '', [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames).ToString(), [System.Text.RegularExpressions.Regex]::Escape("$env:ChocolateyInstall\bin") + '(?>;)?', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase) | ForEach-Object { [System.Environment]::SetEnvironmentVariable('PATH', $_, 'User') }
    [System.Text.RegularExpressions.Regex]::Replace([Microsoft.Win32.Registry]::LocalMachine.OpenSubKey('SYSTEM\CurrentControlSet\Control\Session Manager\Environment\').GetValue('PATH', '', [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames).ToString(), [System.Text.RegularExpressions.Regex]::Escape("$env:ChocolateyInstall\bin") + '(?>;)?', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase) | ForEach-Object { [System.Environment]::SetEnvironmentVariable('PATH', $_, 'Machine') }
    #Clear Temp in Appdata
    Remove-Item -Path $env:LOCALAPPDATA\Temp\* -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $env:LOCALAPPDATA\NuGet -Recurse -Force -ErrorAction SilentlyContinue
}
[xml]$xaml = @'
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
    xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
    Title="Windows Setup" Height="370" Width="600"
    ResizeMode="CanMinimize" WindowStartupLocation="CenterScreen"
    x:Name="Window">
<Grid Margin="25,25,25,25">
    <Grid.RowDefinitions>
        <RowDefinition Height="71*" />
        <RowDefinition Height="60*" />
        <RowDefinition Height="25*"/>
    </Grid.RowDefinitions>

    <Grid.ColumnDefinitions>
        <ColumnDefinition Width="*" />
        <ColumnDefinition Width="*" />
    </Grid.ColumnDefinitions>

    <Label x:Name="Label1" Content="Windows Settings" HorizontalAlignment="Left" Grid.Row="0" VerticalAlignment="Top" Margin="-4,-28,0,0" Height="28" Width="107"/>
    <CheckBox x:Name="WinExplorerSetup" Content="Setup Explorer and Taskbar" HorizontalAlignment="Left" Grid.Row="0" VerticalAlignment="Top" IsChecked="True" Height="20" Width="166"/>
    <CheckBox x:Name="WinAppRemove" Content="Remove Built in Windows apps" HorizontalAlignment="Left" Grid.Row="0" VerticalAlignment="Top" IsChecked="True" Margin="0,20,0,0" Height="20" Width="187"/>
    <CheckBox x:Name="WinLangSetup" Content="Set Language, Region and Keyboard" HorizontalAlignment="Left" Grid.Row="0" VerticalAlignment="Top" IsChecked="True" Margin="0,40,0,0" Height="20" Width="214"/>
    <CheckBox x:Name="WinNetSetup" Content="Enable firewall rule for Remote Desktop" HorizontalAlignment="Left" VerticalAlignment="Top" IsChecked="True" Height="20" Width="232" Margin="0,60,0,0"/>
    <CheckBox x:Name="WinProxySetup" Content="Disable Automatically Detect proxy settings" HorizontalAlignment="Left" Grid.Row="0" VerticalAlignment="Top" IsChecked="True" Margin="0,80,0,0" Height="20" Width="253"/>
    <CheckBox x:Name="WinTimeSetup" Content="Set time and timezone automatically" HorizontalAlignment="Left" Grid.Row="0" VerticalAlignment="Top" Margin="0,100,0,0" Height="20" Width="214" IsChecked="True"/>

    <CheckBox x:Name="WinPowerSetup" Content="Set High Perfomance power plan" HorizontalAlignment="Left" Grid.Row="0" VerticalAlignment="Top" Grid.Column="1" IsChecked="True" Height="20" Width="197"/>
    <CheckBox x:Name="PowerDisplayTimer" Content="Disable turn off display timer" HorizontalAlignment="Left" Grid.Row="0" VerticalAlignment="Top" Grid.Column="1" IsChecked="True" Margin="0,20,0,0" Height="20" Width="175"/>
    <CheckBox x:Name="PowerComputerTimer" Content="Disable Computer sleep timer" HorizontalAlignment="Left" Grid.Row="0" VerticalAlignment="Top" Grid.Column="1" IsChecked="True" Margin="0,40,0,0" Height="20" Width="183"/>
    <CheckBox x:Name="Option4" Content="Option4" HorizontalAlignment="Left" VerticalAlignment="Top" Grid.Column="1" Margin="0,60,0,0" Height="20" Width="67" Visibility="Hidden"/>
    <CheckBox Content="Option5" HorizontalAlignment="Left" Grid.Row="0" VerticalAlignment="Top" Grid.Column="1" Margin="0,80,0,0" Height="20" Width="67" Visibility="Hidden"/>
    <CheckBox Content="Option6" HorizontalAlignment="Left" Grid.Row="0" VerticalAlignment="Top" Grid.Column="1" Margin="0,100,0,0" Height="20" Width="67" Visibility="Hidden"/>
    <Label x:Name="Label2" Content="Application Setup" HorizontalAlignment="Left" Grid.Column="0" VerticalAlignment="Top" Margin="-4,125,0,0" Height="25" Width="104" Grid.RowSpan="2"/>
    <CheckBox x:Name="Chrome" Content="Chrome" HorizontalAlignment="Left" Grid.Row="1" VerticalAlignment="Top" IsChecked="True" Margin="0,20,0,0" Height="20" Width="68"/>
    <CheckBox x:Name="Firefox" Content="Firefox" HorizontalAlignment="Left" Grid.Row="1" VerticalAlignment="Top" IsChecked="True" Margin="0,40,0,0" Height="20" Width="58"/>
    <CheckBox x:Name="Zoom" Content="Zoom" HorizontalAlignment="Left" Grid.Row="1" VerticalAlignment="Top" Margin="0,60,0,0" Height="20" Width="51" IsChecked="True"/>
    <CheckBox x:Name="Teams" Content="Teams" HorizontalAlignment="Left" Grid.Row="1" Margin="0,80,0,0" Height="20" Width="58" VerticalAlignment="Top"/>
    <CheckBox x:Name="WinRAR" Content="WinRAR" HorizontalAlignment="Right" Grid.Row="1" VerticalAlignment="Top" IsChecked="True" Margin="0,20,63,0" Height="20" Width="62"/>
    <CheckBox x:Name="_7Zip" Content="7zip" HorizontalAlignment="Right" Grid.Row="1" VerticalAlignment="Top" Margin="0,40,82,0" Height="20" Width="43"/>
    <CheckBox Content="AppB3" HorizontalAlignment="Right" Grid.Row="1" VerticalAlignment="Top" Margin="0,60,0,0" Height="20" Width="125" Visibility="Hidden"/>
    <CheckBox Content="AppB4" HorizontalAlignment="Right" Grid.Row="1" Margin="0,80,0,0" Height="20" Width="125" VerticalAlignment="Top" Visibility="Hidden"/>

    <CheckBox x:Name="AnyDesk" Content="AnyDesk" HorizontalAlignment="Left" Grid.Row="1" Grid.Column="1" VerticalAlignment="Top" IsChecked="True" Margin="0,20,0,0" Height="20" Width="67"/>
    <CheckBox x:Name="Team_Viewer" Content="Team Viewer" HorizontalAlignment="Left" Grid.Row="1" Grid.Column="1" VerticalAlignment="Top" Margin="0,40,0,0" Height="20" Width="86"/>
    <CheckBox Content="AppC3" HorizontalAlignment="Left" Grid.Row="1" Grid.Column="1" VerticalAlignment="Top" Margin="0,60,0,0" Height="20" Width="135" Visibility="Hidden"/>
    <CheckBox Content="AppC4" HorizontalAlignment="Left" Grid.Row="1" Grid.Column="1" Margin="0,80,0,0" Height="20" Width="135" VerticalAlignment="Top" Visibility="Hidden"/>
    <CheckBox x:Name="ACReader" Content="Acrobat Reader DC" HorizontalAlignment="Right" Grid.Row="1" Grid.Column="1" VerticalAlignment="Top" IsChecked="True" Margin="0,20,0,0" Height="20" Width="125"/>
    <CheckBox x:Name="PuTTY" Content="PuTTY" HorizontalAlignment="Right" Grid.Row="1" Grid.Column="1" VerticalAlignment="Top" Margin="0,40,72,0" Height="20" Width="53"/>
    <CheckBox x:Name="FileZilla" Content="FileZilla" HorizontalAlignment="Right" Grid.Row="1" Grid.Column="1" VerticalAlignment="Top" Margin="0,60,62,0" Height="20" Width="63"/>
    <CheckBox x:Name="VSCode" Content="Visual Studio Code" HorizontalAlignment="Right" Grid.Row="1" Grid.Column="1" Margin="0,80,0,0" Height="20" Width="125" VerticalAlignment="Top"/>
    <Button x:Name="RunButton" Content="Run The Setup" HorizontalAlignment="Left" Margin="219,4,0,0" Grid.Row="2" VerticalAlignment="Top" Height="40" Width="110" FontSize="14" IsDefault="True" IsEnabled="True" Grid.ColumnSpan="2"/>
    <Button x:Name="ConsoleButton" Content="Console" HorizontalAlignment="Left" Margin="-50,0,0,0" VerticalAlignment="Top" RenderTransformOrigin="0.5,0.5" Width="69" Height="20" Visibility="Hidden">
        <Button.RenderTransform>
            <TransformGroup>
                <ScaleTransform/>
                <SkewTransform/>
                <RotateTransform Angle="90"/>
                <TranslateTransform/>
            </TransformGroup>
        </Button.RenderTransform>
    </Button>
    <ProgressBar x:Name="Progress" HorizontalAlignment="Left" Height="26" Margin="10,11,0,0" VerticalAlignment="Top" Width="558" Grid.Row="2" Grid.ColumnSpan="2" Value="-1" IsEnabled="False" Visibility="Hidden"/>
</Grid>
</Window>
'@
Add-Type -AssemblyName PresentationFramework
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader) 
$WinExplorerSetup = $window.FindName("WinExplorerSetup")
$WinAppRemove = $window.FindName("WinAppRemove")
$WinLangSetup = $window.FindName("WinLangSetup")
$WinNetSetup = $window.FindName("WinNetSetup")
$WinProxySetup = $window.FindName("WinProxySetup")
$WinTimeSetup = $window.FindName("WinTimeSetup")

$WinPowerSetup = $window.FindName("WinPowerSetup")
$PowerDisplayTimer = $window.FindName("PowerDisplayTimer")
$PowerComputerTimer = $window.FindName("PowerComputerTimer")
$Option4 = $window.FindName("Option4")
$Option5 = $window.FindName("Option5")
$Option6 = $window.FindName("Option6")

$Chrome = $window.FindName("Chrome")
$Firefox = $window.FindName("Firefox")
$Zoom = $window.FindName("Zoom")
$Teams = $window.FindName("Teams")

$WinRAR = $window.FindName("WinRAR")
$_7Zip = $window.FindName("_7Zip")
$AppB3 = $window.FindName("AppB3")
$AppB4 = $window.FindName("AppB4")

$AnyDesk = $window.FindName("AnyDesk")
$Team_Viewer = $window.FindName("Team_Viewer")
$AppC3 = $window.FindName("AppC3")
$AppC4 = $window.FindName("AppC4")

$ACReader = $window.FindName("ACReader")
$PuTTY = $window.FindName("PuTTY")
$FileZilla = $window.FindName("FileZilla")
$VSCode = $window.FindName("VSCode")

#$ProgressBar = $window.FindName("ProgressBar")

$RunButton = $window.FindName("RunButton")
$ConsoleButton = $window.FindName("ConsoleButton")

$ConsoleButton.Add_Click({ $Null = [Win32.Functions]::ShowWindow($hWnd, $SW_SHOW) })
$programs = New-Object -TypeName System.Collections.ArrayList

$RunButton.Add_Click({
        If ($WinLangSetup.IsChecked) { WinLangSetup }
        If ($WinNetSetup.IsChecked) { WinNetSetup }
        If ($WinProxySetup.IsChecked) { WinProxySetup }
        If ($WinTimeSetup.IsChecked) { WinTimeSetup }
        If ($WinExplorerSetup.IsChecked) { WinExplorerSetup }
        If ($WinPowerSetup.IsChecked) { WinPowerSetup }
        If ($PowerDisplayTimer.IsChecked) { PowerDisplayTimer }
        If ($PowerComputerTimer.IsChecked) { PowerComputerTimer }
        If ($WinAppRemove.IsChecked) { WinAppRemove }
        If ($Option4.IsChecked) { }
        If ($Option5.IsChecked) { }
        If ($Option6.IsChecked) { }
        If ($Chrome.IsChecked) {
            $programs.AddRange(@("googlechrome"))
        }
        If ($Firefox.IsChecked) {
            $programs.AddRange(@("firefox"))
        }
        If ($Zoom.IsChecked) {
            $programs.AddRange(@("zoom"))
        }
        If ($Teams.IsChecked) {
            $programs.AddRange(@("microsoft-teams.install"))
        }
        If ($WinRAR.IsChecked) {
            $programs.AddRange(@("WinRAR"))
        }
        If ($_7Zip.IsChecked) {
            $programs.AddRange(@("7Zip"))
        }
        If ($AppB3.IsChecked) {
        }
        If ($AppB4.IsChecked) {
        }
        If ($AnyDesk.IsChecked) {
            $programs.AddRange(@("anydesk.install"))
        }
        If ($Team_Viewer.IsChecked) {
            $programs.AddRange(@("teamviewer.host"))
        }
        If ($AppC3.IsChecked) {
        }
        If ($AppC4.IsChecked) {
        }
        If ($ACReader.IsChecked) {
            $programs.AddRange(@("adobereader"))
        }
        If ($PuTTY.IsChecked) {
            $programs.AddRange(@("putty"))
        }
        If ($FileZilla.IsChecked) {
            $programs.AddRange(@("filezilla"))
        }
        If ($VSCode.IsChecked) {
            $programs.AddRange(@("vscode"))
        }
        if ($Chrome.IsChecked -or $Firefox.IsChecked -or $Zoom.IsChecked -or $Teams.IsChecked -or $WinRAR.IsChecked -or $_7Zip.IsChecked -or $AppB3.IsChecked -or $AppB4.IsChecked -or $AnyDesk.IsChecked -or $Team_Viewer.IsChecked -or $AppC3.IsChecked -or $AppC4.IsChecked -or $ACReader.IsChecked -or $PuTTY.IsChecked -or $FileZilla.IsChecked -or $VSCode.IsChecked) {
            ChocoInstall
            foreach ($program in $programs) {
                choco install $program -y
            }
            ChocoRemove
        }
        $RunButton.IsEnabled = $false
        $RunButton.Content = "Setup Complete!"
    })
$window.ShowDialog() | Out-Null
