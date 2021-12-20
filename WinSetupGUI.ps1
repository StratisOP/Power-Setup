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
Add-Type -AssemblyName PresentationFramework
[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
    xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
    Title="Windows Setup" Height="350" Width="600"
    ResizeMode="CanMinimize" WindowStartupLocation="CenterScreen"
    x:Name="Window">
    <Grid Margin="10">
    <Grid.RowDefinitions>
    <RowDefinition Height="*" />
    <RowDefinition Height="*" />
</Grid.RowDefinitions>

<Grid.ColumnDefinitions>
    <ColumnDefinition Width="*" />
    <ColumnDefinition Width="*" />
</Grid.ColumnDefinitions>

<Label x:Name="Label1" Content="Windows Settings" Grid.Column="0"  Grid.RowSpan="2"/>
        <CheckBox x:Name="WinExplorerSetup" Content="Setup Explorer and Taskbar" HorizontalAlignment="Center" Grid.Row="0" VerticalAlignment="Top" IsChecked="True" Margin="0,20,0,0"  Height="20" Width="269"/>
        <CheckBox x:Name="WinAppRemove" Content="Remove Built in Windows apps" HorizontalAlignment="Center" Grid.Row="0" VerticalAlignment="Top" IsChecked="True" Margin="0,40,0,0"  Height="20" Width="269"/>
        <CheckBox x:Name="WinLangSetup" Content="Set Language, Region and Keyboard" HorizontalAlignment="Center" Grid.Row="0" VerticalAlignment="Top" IsChecked="True" Margin="0,60,0,0"  Height="20" Width="269"/>
        <CheckBox x:Name="WinNetSetup" Content="Enable firewall rule for Remote Desktop" HorizontalAlignment="Center" Grid.Row="0" VerticalAlignment="Top" IsChecked="True" Margin="0,80,0,0"  Height="20" Width="269"/>
        <CheckBox x:Name="WinProxySetup" Content="Disable Automatically Detect proxy settings" HorizontalAlignment="Center" Grid.Row="0" VerticalAlignment="Top" IsChecked="True" Margin="0,100,0,0"  Height="20" Width="269"/>
        <CheckBox x:Name="WinTimeSetup" Content="Set time and timezone automatically" HorizontalAlignment="Center" Grid.Row="0" VerticalAlignment="Top" Margin="0,120,0,0"  Height="20" Width="269" IsChecked="True"/>

        <CheckBox x:Name="WinPowerSetup" Content="Set High Perfomance power plan" HorizontalAlignment="Center" Grid.Row="0" VerticalAlignment="Top" Grid.Column="1" IsChecked="True" Margin="0,20,0,0"  Height="20" Width="269"/>
        <CheckBox x:Name="PowerDisplayTimer" Content="Disable turn off display timer" HorizontalAlignment="Center" Grid.Row="0" VerticalAlignment="Top" Grid.Column="1" IsChecked="True" Margin="0,40,0,0"  Height="20" Width="269"/>
        <CheckBox x:Name="PowerComputerTimer" Content="Disable Computer sleep timer" HorizontalAlignment="Center" Grid.Row="0" VerticalAlignment="Top" Grid.Column="1" IsChecked="True" Margin="0,60,0,0"  Height="20" Width="269"/>
        <CheckBox Content="Option4" HorizontalAlignment="Center" Grid.Row="0" VerticalAlignment="Top" Grid.Column="1" Margin="0,80,0,0"  Height="20" Width="269" Visibility="Hidden"/>
        <CheckBox Content="Option5" HorizontalAlignment="Center" Grid.Row="0" VerticalAlignment="Top" Grid.Column="1" Margin="0,100,0,0"  Height="20" Width="269" Visibility="Hidden"/>
        <CheckBox Content="Option6" HorizontalAlignment="Center" Grid.Row="0" VerticalAlignment="Top" Grid.Column="1" Margin="0,120,0,0"  Height="20" Width="269" Visibility="Hidden"/>
        <Label x:Name="Label2" Content="Application Setup" Grid.Column="0" Grid.Row="2"/>
        <CheckBox x:Name="Chrome" Content="Chrome" HorizontalAlignment="Left" Grid.Row="2" VerticalAlignment="Top" IsChecked="True" Margin="10,25,0,0"  Height="20" Width="135"/>
        <CheckBox x:Name="Firefox" Content="Firefox" HorizontalAlignment="Left" Grid.Row="2" VerticalAlignment="Top" IsChecked="True" Margin="10,45,0,0"  Height="20" Width="135"/>
        <CheckBox x:Name="Zoom" Content="Zoom" HorizontalAlignment="Left" Grid.Row="2" VerticalAlignment="Top" Margin="10,65,0,0"  Height="20" Width="135" IsChecked="True"/>
        <CheckBox x:Name="Teams" Content="Teams" HorizontalAlignment="Left" Grid.Row="2" Margin="10,85,0,0"  Height="20" Width="135" VerticalAlignment="Top"/>
        <CheckBox x:Name="WinRAR" Content="WinRAR" HorizontalAlignment="Right" Grid.Row="2" VerticalAlignment="Top" IsChecked="True" Margin="0,25,10,0"  Height="20" Width="125"/>
        <CheckBox x:Name="_7Zip" Content="7zip" HorizontalAlignment="Right" Grid.Row="2" VerticalAlignment="Top" Margin="0,45,10,0"  Height="20" Width="125"/>
        <CheckBox Content="AppB3" HorizontalAlignment="Right" Grid.Row="2" VerticalAlignment="Top" Margin="0,65,10,0"  Height="20" Width="125" Visibility="Hidden"/>
        <CheckBox Content="AppB4" HorizontalAlignment="Right" Grid.Row="2" Margin="0,85,10,0"  Height="20" Width="125" VerticalAlignment="Top" Visibility="Hidden"/>

        <CheckBox x:Name="AnyDesk" Content="AnyDesk" HorizontalAlignment="Left" Grid.Row="2" Grid.Column="1" VerticalAlignment="Top" IsChecked="True" Margin="10,25,0,0"  Height="20" Width="135"/>
        <CheckBox x:Name="Team_Viewer" Content="Team Viewer" HorizontalAlignment="Left" Grid.Row="2" Grid.Column="1" VerticalAlignment="Top" Margin="10,45,0,0"  Height="20" Width="135"/>
        <CheckBox Content="AppC3" HorizontalAlignment="Left" Grid.Row="2" Grid.Column="1" VerticalAlignment="Top" Margin="10,65,0,0"  Height="20" Width="135" Visibility="Hidden"/>
        <CheckBox Content="AppC4" HorizontalAlignment="Left" Grid.Row="2" Grid.Column="1" Margin="10,85,0,0"  Height="20" Width="135" VerticalAlignment="Top" Visibility="Hidden"/>
        <CheckBox x:Name="ACReader" Content="Acrobat Reader DC" HorizontalAlignment="Right" Grid.Row="2" Grid.Column="1" VerticalAlignment="Top" IsChecked="True" Margin="0,25,10,0"  Height="20" Width="125"/>
        <CheckBox x:Name="PuTTY" Content="PuTTY" HorizontalAlignment="Right" Grid.Row="2" Grid.Column="1" VerticalAlignment="Top" Margin="0,45,10,0"  Height="20" Width="125"/>
        <CheckBox x:Name="FileZilla" Content="FileZilla" HorizontalAlignment="Right" Grid.Row="2" Grid.Column="1" VerticalAlignment="Top" Margin="0,65,10,0"  Height="20" Width="125"/>
        <CheckBox x:Name="VSD" Content="Visual Studio Code" HorizontalAlignment="Right" Grid.Row="2" Grid.Column="1" Margin="0,85,10,0"  Height="20" Width="125" VerticalAlignment="Top"/>
        <Button x:Name="RunButton" Content="Run The Setup" HorizontalAlignment="Left" Margin="234,105,0,0" Grid.Row="1" VerticalAlignment="Top" Height="38" Width="110" FontSize="14" Grid.ColumnSpan="2"/>
    </Grid>
</Window>
"@
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
$VSD = $window.FindName("VSD")

$RunButton = $window.FindName("RunButton")

$RunButton.Add_Click({
        If ($WinLangSetup.IsChecked) {
            #Set Language, region, and keyboard languages
            Set-Culture en-US
            Set-WinUILanguageOverride -Language en-US
            Set-WinUserLanguageList en-US, el-GR -Force
            Set-WinHomeLocation -GeoId 98
            Set-WinSystemLocale -SystemLocale el-GR #On next boot
        }
        If ($WinNetSetup.IsChecked) {
            #Enable firewall rule for Remote Desktop - User Mode (TCP & UDP)
            Get-NetFirewallRule -DisplayName "Remote Desktop - User*" | Set-NetFirewallRule -Enabled true

            #Enable firewall rule for Remote Desktop - User Mode (TCP & UDP) (Greek Firewall Rules)
            Get-NetFirewallRule -DisplayName "Απομακρυσμένη επιφάνεια εργασίας - Λειτουργία χρήστη*" | Set-NetFirewallRule -Enabled true
        }
        If ($WinProxySetup.IsChecked) {
            #Disable Automatically Detect proxy settings
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" AutoDetect 0
        }
        If ($WinTimeSetup.IsChecked) {
            #Set time automatically
            Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters Type NTP
            #Set timezone automatically 
            Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate Start 3
        }
        If ($WinExplorerSetup.IsChecked) {
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
        If ($WinPowerSetup.IsChecked) {
            #Sets active power plan to High Performance
            powercfg -setactive 8C5E7fda-e8bf-4a96-9a85-a6e23a8c635c
            #Disables Hibernation
            powercfg -hibernate off
        }
        If ($PowerDisplayTimer.IsChecked) {
            #Changes the value of "Turn off the display:"
            powercfg -change -monitor-timeout-ac 0
        }
        If ($PowerComputerTimer.IsChecked) {
            #Changes the value of "Put the computer to sleep:"
            powercfg -change -standby-timeout-ac 0
        }
        If ($WinAppRemove.IsChecked) {
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
        If ($Option4.IsChecked) {
        }
        If ($Option5.IsChecked) {
        }
        If ($Option6.IsChecked) {
        }
        if ($Chrome.IsChecked -or $Firefox.IsChecked -or $Zoom.IsChecked -or $Teams.IsChecked -or $WinRAR.IsChecked -or $_7Zip.IsChecked -or $AppB3.IsChecked -or $AppB4.IsChecked -or $AnyDesk.IsChecked -or $Team_Viewer.IsChecked -or $AppC3.IsChecked -or $AppC4.IsChecked -or $ACReader.IsChecked -or $PuTTY.IsChecked -or $FileZilla.IsChecked -or $VSD.IsChecked) {
            #Install Chocolatey
            $choco = @'
            [CmdletBinding(DefaultParameterSetName = 'Default')]
            param(
                # The URL to download Chocolatey from. This defaults to the value of
                # $env:chocolateyDownloadUrl, if it is set, and otherwise falls back to the
                # official Chocolatey community repository to download the Chocolatey package.
                [Parameter(Mandatory = $false)]
                [string]
                $ChocolateyDownloadUrl = $env:chocolateyDownloadUrl,
            
                # Specifies a target version of Chocolatey to install. By default, the latest
                # stable version is installed. This will use the value in
                # $env:chocolateyVersion by default, if that environment variable is present.
                # This parameter is ignored if -ChocolateyDownloadUrl is set.
                [Parameter(Mandatory = $false)]
                [string]
                $ChocolateyVersion = $env:chocolateyVersion,
            
                # If set, uses built-in Windows decompression tools instead of 7zip when
                # unpacking the downloaded nupkg. This will be set by default if
                # $env:chocolateyUseWindowsCompression is set to a value other than 'false' or '0'.
                #
                # This parameter will be ignored in PS 5+ in favour of using the
                # Expand-Archive built in PowerShell cmdlet directly.
                [Parameter(Mandatory = $false)]
                [switch]
                $UseNativeUnzip = $(
                    $envVar = "$env:chocolateyUseWindowsCompression".Trim()
                    $value = $null
                    if ([bool]::TryParse($envVar, [ref] $value)) {
                        $value
                    } elseif ([int]::TryParse($envVar, [ref] $value)) {
                        [bool]$value
                    } else {
                        [bool]$envVar
                    }
                ),
            
                # If set, ignores any configured proxy. This will override any proxy
                # environment variables or parameters. This will be set by default if
                # $env:chocolateyIgnoreProxy is set to a value other than 'false' or '0'.
                [Parameter(Mandatory = $false)]
                [switch]
                $IgnoreProxy = $(
                    $envVar = "$env:chocolateyIgnoreProxy".Trim()
                    $value = $null
                    if ([bool]::TryParse($envVar, [ref] $value)) {
                        $value
                    }
                    elseif ([int]::TryParse($envVar, [ref] $value)) {
                        [bool]$value
                    }
                    else {
                        [bool]$envVar
                    }
                ),
            
                # Specifies the proxy URL to use during the download. This will default to
                # the value of $env:chocolateyProxyLocation, if any is set.
                [Parameter(ParameterSetName = 'Proxy', Mandatory = $false)]
                [string]
                $ProxyUrl = $env:chocolateyProxyLocation,
            
                # Specifies the credential to use for an authenticated proxy. By default, a
                # proxy credential will be constructed from the $env:chocolateyProxyUser and
                # $env:chocolateyProxyPassword environment variables, if both are set.
                [Parameter(ParameterSetName = 'Proxy', Mandatory = $false)]
                [System.Management.Automation.PSCredential]
                $ProxyCredential
            )
            
            #region Functions
            
            function Get-Downloader {
                <#
                .SYNOPSIS
                Gets a System.Net.WebClient that respects relevant proxies to be used for
                downloading data.
            
                .DESCRIPTION
                Retrieves a WebClient object that is pre-configured according to specified
                environment variables for any proxy and authentication for the proxy.
                Proxy information may be omitted if the target URL is considered to be
                bypassed by the proxy (originates from the local network.)
            
                .PARAMETER Url
                Target URL that the WebClient will be querying. This URL is not queried by
                the function, it is only a reference to determine if a proxy is needed.
            
                .EXAMPLE
                Get-Downloader -Url $fileUrl
            
                Verifies whether any proxy configuration is needed, and/or whether $fileUrl
                is a URL that would need to bypass the proxy, and then outputs the
                already-configured WebClient object.
                #>
                [CmdletBinding()]
                param(
                    [Parameter(Mandatory = $false)]
                    [string]
                    $Url,
            
                    [Parameter(Mandatory = $false)]
                    [string]
                    $ProxyUrl,
            
                    [Parameter(Mandatory = $false)]
                    [System.Management.Automation.PSCredential]
                    $ProxyCredential
                )
            
                $downloader = New-Object System.Net.WebClient
            
                $defaultCreds = [System.Net.CredentialCache]::DefaultCredentials
                if ($defaultCreds) {
                    $downloader.Credentials = $defaultCreds
                }
            
                if ($ProxyUrl) {
                    # Use explicitly set proxy.
                    $proxy = New-Object System.Net.WebProxy -ArgumentList $ProxyUrl, <# bypassOnLocal: #> $true
            
                    $proxy.Credentials = if ($ProxyCredential) {
                        $ProxyCredential.GetNetworkCredential()
                    } elseif ($defaultCreds) {
                        $defaultCreds
                    } else {
                        (Get-Credential).GetNetworkCredential()
                    }
            
                    if (-not $proxy.IsBypassed($Url)) {
                        $downloader.Proxy = $proxy
                    }
                } else {
                }
            
                $downloader
            }
            
            function Request-String {
                <#
                .SYNOPSIS
                Downloads content from a remote server as a string.
            
                .DESCRIPTION
                Downloads target string content from a URL and outputs the resulting string.
                Any existing proxy that may be in use will be utilised.
            
                .PARAMETER Url
                URL to download string data from.
            
                .PARAMETER ProxyConfiguration
                A hashtable containing proxy parameters (ProxyUrl and ProxyCredential)
            
                .EXAMPLE
                Request-String https://community.chocolatey.org/install.ps1
            
                Retrieves the contents of the string data at the targeted URL and outputs
                it to the pipeline.
                #>
                [CmdletBinding()]
                param(
                    [Parameter(Mandatory = $true)]
                    [string]
                    $Url,
            
                    [Parameter(Mandatory = $false)]
                    [hashtable]
                    $ProxyConfiguration
                )
            
                (Get-Downloader $url @ProxyConfiguration).DownloadString($url)
            }
            
            function Request-File {
                <#
                .SYNOPSIS
                Downloads a file from a given URL.
            
                .DESCRIPTION
                Downloads a target file from a URL to the specified local path.
                Any existing proxy that may be in use will be utilised.
            
                .PARAMETER Url
                URL of the file to download from the remote host.
            
                .PARAMETER File
                Local path for the file to be downloaded to.
            
                .PARAMETER ProxyConfiguration
                A hashtable containing proxy parameters (ProxyUrl and ProxyCredential)
            
                .EXAMPLE
                Request-File -Url https://community.chocolatey.org/install.ps1 -File $targetFile
            
                Downloads the install.ps1 script to the path specified in $targetFile.
                #>
                [CmdletBinding()]
                param(
                    [Parameter(Mandatory = $false)]
                    [string]
                    $Url,
            
                    [Parameter(Mandatory = $false)]
                    [string]
                    $File,
            
                    [Parameter(Mandatory = $false)]
                    [hashtable]
                    $ProxyConfiguration
                )
            
                (Get-Downloader $url @ProxyConfiguration).DownloadFile($url, $file)
            }
            
            function Set-PSConsoleWriter {
                <#
                .SYNOPSIS
                Workaround for a bug in output stream handling PS v2 or v3.
            
                .DESCRIPTION
                PowerShell v2/3 caches the output stream. Then it throws errors due to the
                FileStream not being what is expected. Fixes "The OS handle's position is
                not what FileStream expected. Do not use a handle simultaneously in one
                FileStream and in Win32 code or another FileStream." error.
            
                .EXAMPLE
                Set-PSConsoleWriter
            
                .NOTES
                General notes
                #>
            
                [CmdletBinding()]
                param()
                if ($PSVersionTable.PSVersion.Major -gt 3) {
                    return
                }
            
                try {
                    # http://www.leeholmes.com/blog/2008/07/30/workaround-the-os-handles-position-is-not-what-filestream-expected/ plus comments
                    $bindingFlags = [Reflection.BindingFlags] "Instance,NonPublic,GetField"
                    $objectRef = $host.GetType().GetField("externalHostRef", $bindingFlags).GetValue($host)
            
                    $bindingFlags = [Reflection.BindingFlags] "Instance,NonPublic,GetProperty"
                    $consoleHost = $objectRef.GetType().GetProperty("Value", $bindingFlags).GetValue($objectRef, @())
                    [void] $consoleHost.GetType().GetProperty("IsStandardOutputRedirected", $bindingFlags).GetValue($consoleHost, @())
            
                    $bindingFlags = [Reflection.BindingFlags] "Instance,NonPublic,GetField"
                    $field = $consoleHost.GetType().GetField("standardOutputWriter", $bindingFlags)
                    $field.SetValue($consoleHost, [Console]::Out)
            
                    [void] $consoleHost.GetType().GetProperty("IsStandardErrorRedirected", $bindingFlags).GetValue($consoleHost, @())
                    $field2 = $consoleHost.GetType().GetField("standardErrorWriter", $bindingFlags)
                    $field2.SetValue($consoleHost, [Console]::Error)
                } catch {
                }
            }
            
            function Test-ChocolateyInstalled {
                [CmdletBinding()]
                param()
            
                $checkPath = if ($env:ChocolateyInstall) { $env:ChocolateyInstall } else { "$env:PROGRAMDATA\chocolatey" }
            
                if ($Command = Get-Command choco -CommandType Application -ErrorAction Ignore) {
                    # choco is on the PATH, assume it's installed
                    $true
                }
                elseif (-not (Test-Path $checkPath)) {
                    # Install folder doesn't exist
                    $false
                }
                elseif (-not (Get-ChildItem -Path $checkPath)) {
                    # Install folder exists but is empty
                    $false
                }
                else {
                    # Install folder exists and is not empty
                    $true
                }
            }
            
            function Install-7zip {
                [CmdletBinding()]
                param(
                    [Parameter(Mandatory = $true)]
                    [string]
                    $Path,
            
                    [Parameter(Mandatory = $false)]
                    [hashtable]
                    $ProxyConfiguration
                )
            
                if (-not (Test-Path ($Path))) {
                    Request-File -Url 'https://community.chocolatey.org/7za.exe' -File $Path -ProxyConfiguration $ProxyConfiguration
            
                }
                else {
                }
            }
            
            #endregion Functions
            
            #region Pre-check
            
            # Ensure we have all our streams setup correctly, needed for older PSVersions.
            Set-PSConsoleWriter
            
            if (Test-ChocolateyInstalled) {
                $message = @(
                    "An existing Chocolatey installation was detected. Installation will not continue."
                    "For security reasons, this script will not overwrite existing installations."
                    ""
                    "Please use `choco upgrade chocolatey` to handle upgrades of Chocolatey itself."
                ) -join [Environment]::NewLine
            
            
                return
            }
            
            #endregion Pre-check
            
            #region Setup
            
            $proxyConfig = if ($IgnoreProxy -or -not $ProxyUrl) {
                @{}
            } else {
                $config = @{
                    ProxyUrl = $ProxyUrl
                }
            
                if ($ProxyCredential) {
                    $config['ProxyCredential'] = $ProxyCredential
                } elseif ($env:chocolateyProxyUser -and $env:chocolateyProxyPassword) {
                    $securePass = ConvertTo-SecureString $env:chocolateyProxyPassword -AsPlainText -Force
                    $config['ProxyCredential'] = [System.Management.Automation.PSCredential]::new($env:chocolateyProxyUser, $securePass)
                }
            
                $config
            }
            
            # Attempt to set highest encryption available for SecurityProtocol.
            # PowerShell will not set this by default (until maybe .NET 4.6.x). This
            # will typically produce a message for PowerShell v2 (just an info
            # message though)
            try {
                # Set TLS 1.2 (3072) as that is the minimum required by Chocolatey.org.
                # Use integers because the enumeration value for TLS 1.2 won't exist
                # in .NET 4.0, even though they are addressable if .NET 4.5+ is
                # installed (.NET 4.5 is an in-place upgrade).
                [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
            }
            catch {
                $errorMessage = @(
                    'Unable to set PowerShell to use TLS 1.2. This is required for contacting Chocolatey as of 03 FEB 2020.'
                    'https://blog.chocolatey.org/2020/01/remove-support-for-old-tls-versions/.'
                    'If you see underlying connection closed or trust errors, you may need to do one or more of the following:'
                    '(1) upgrade to .NET Framework 4.5+ and PowerShell v3+,'
                    '(2) Call [System.Net.ServicePointManager]::SecurityProtocol = 3072; in PowerShell prior to attempting installation,'
                    '(3) specify internal Chocolatey package location (set $env:chocolateyDownloadUrl prior to install or host the package internally),'
                    '(4) use the Download + PowerShell method of install.'
                    'See https://docs.chocolatey.org/en-us/choco/setup for all install options.'
                ) -join [Environment]::NewLine
            }
            
            if ($ChocolateyDownloadUrl) {
                if ($ChocolateyVersion) {
                }
            
            } elseif ($ChocolateyVersion) {
                $ChocolateyDownloadUrl = "https://community.chocolatey.org/api/v2/package/chocolatey/$ChocolateyVersion"
            } else {
                $queryString = [uri]::EscapeUriString("((Id eq 'chocolatey') and (not IsPrerelease)) and IsLatestVersion")
                $queryUrl = 'https://community.chocolatey.org/api/v2/Packages()?$filter={0}' -f $queryString
            
                [xml]$result = Request-String -Url $queryUrl -ProxyConfiguration $proxyConfig
                $ChocolateyDownloadUrl = $result.feed.entry.content.src
            }
            
            if (-not $env:TEMP) {
                $env:TEMP = Join-Path $env:SystemDrive -ChildPath 'temp'
            }
            
            $chocoTempDir = Join-Path $env:TEMP -ChildPath "chocolatey"
            $tempDir = Join-Path $chocoTempDir -ChildPath "chocoInstall"
            
            if (-not (Test-Path $tempDir -PathType Container)) {
                $null = New-Item -Path $tempDir -ItemType Directory
            }
            
            $file = Join-Path $tempDir "chocolatey.zip"
            
            #endregion Setup
            
            #region Download & Extract Chocolatey
            
            Request-File -Url $ChocolateyDownloadUrl -File $file -ProxyConfiguration $proxyConfig
            
            if ($PSVersionTable.PSVersion.Major -lt 5) {
                # Determine unzipping method
                # 7zip is the most compatible pre-PSv5.1 so use it unless asked to use builtin
                if ($UseNativeUnzip) {
            
                    try {
                        $shellApplication = New-Object -ComObject Shell.Application
                        $zipPackage = $shellApplication.NameSpace($file)
                        $destinationFolder = $shellApplication.NameSpace($tempDir)
                        $destinationFolder.CopyHere($zipPackage.Items(), 0x10)
                    } catch {
                        throw $_
                    }
                } else {
                    $7zaExe = Join-Path $tempDir -ChildPath '7za.exe'
                    Install-7zip -Path $7zaExe -ProxyConfiguration $proxyConfig
            
                    $params = 'x -o"{0}" -bd -y "{1}"' -f $tempDir, $file
            
                    # use more robust Process as compared to Start-Process -Wait (which doesn't
                    # wait for the process to finish in PowerShell v3)
                    $process = New-Object System.Diagnostics.Process
            
                    try {
                        $process.StartInfo = New-Object System.Diagnostics.ProcessStartInfo -ArgumentList $7zaExe, $params
                        $process.StartInfo.RedirectStandardOutput = $true
                        $process.StartInfo.UseShellExecute = $false
                        $process.StartInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
            
                        $null = $process.Start()
                        $process.BeginOutputReadLine()
                        $process.WaitForExit()
            
                        $exitCode = $process.ExitCode
                    }
                    finally {
                        $process.Dispose()
                    }
            
                    $errorMessage = "Unable to unzip package using 7zip. Perhaps try setting `$env:chocolateyUseWindowsCompression = 'true' and call install again. Error:"
                    if ($exitCode -ne 0) {
                        $errorDetails = switch ($exitCode) {
                            1 { "Some files could not be extracted" }
                            2 { "7-Zip encountered a fatal error while extracting the files" }
                            7 { "7-Zip command line error" }
                            8 { "7-Zip out of memory" }
                            255 { "Extraction cancelled by the user" }
                            default { "7-Zip signalled an unknown error (code $exitCode)" }
                        }
            
                        throw ($errorMessage, $errorDetails -join [Environment]::NewLine)
                    }
                }
            } else {
                Microsoft.PowerShell.Archive\Expand-Archive -Path $file -DestinationPath $tempDir -Force
            }
            
            #endregion Download & Extract Chocolatey
            
            #region Install Chocolatey
            
            $toolsFolder = Join-Path $tempDir -ChildPath "tools"
            $chocoInstallPS1 = Join-Path $toolsFolder -ChildPath "chocolateyInstall.ps1"
            
            & $chocoInstallPS1
            
            $chocoInstallVariableName = "ChocolateyInstall"
            $chocoPath = [Environment]::GetEnvironmentVariable($chocoInstallVariableName)
            
            if (-not $chocoPath) {
                $chocoPath = "$env:ALLUSERSPROFILE\Chocolatey"
            }
            
            if (-not (Test-Path ($chocoPath))) {
                $chocoPath = "$env:PROGRAMDATA\chocolatey"
            }
            
            $chocoExePath = Join-Path $chocoPath -ChildPath 'bin'
            
            # Update current process PATH environment variable if it needs updating.
            if ($env:Path -notlike "*$chocoExePath*") {
                $env:Path = [Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine);
            }
            
            $chocoPkgDir = Join-Path $chocoPath -ChildPath 'lib\chocolatey'
            $nupkg = Join-Path $chocoPkgDir -ChildPath 'chocolatey.nupkg'
            
            if (-not (Test-Path $chocoPkgDir -PathType Container)) {
                $null = New-Item -ItemType Directory -Path $chocoPkgDir
            }
            
            Copy-Item -Path $file -Destination $nupkg -Force -ErrorAction SilentlyContinue
            
            #endregion Install Chocolatey
            
            # SIG # Begin signature block
            # MIIZvwYJKoZIhvcNAQcCoIIZsDCCGawCAQExDzANBglghkgBZQMEAgEFADB5Bgor
            # BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
            # KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBiXTlbpVQOoJeX
            # rGtqATyaDXeEHi6Q2pKb3p02Iq/tc6CCFKgwggT+MIID5qADAgECAhANQkrgvjqI
            # /2BAIc4UAPDdMA0GCSqGSIb3DQEBCwUAMHIxCzAJBgNVBAYTAlVTMRUwEwYDVQQK
            # EwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xMTAvBgNV
            # BAMTKERpZ2lDZXJ0IFNIQTIgQXNzdXJlZCBJRCBUaW1lc3RhbXBpbmcgQ0EwHhcN
            # MjEwMTAxMDAwMDAwWhcNMzEwMTA2MDAwMDAwWjBIMQswCQYDVQQGEwJVUzEXMBUG
            # A1UEChMORGlnaUNlcnQsIEluYy4xIDAeBgNVBAMTF0RpZ2lDZXJ0IFRpbWVzdGFt
            # cCAyMDIxMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwuZhhGfFivUN
            # CKRFymNrUdc6EUK9CnV1TZS0DFC1JhD+HchvkWsMlucaXEjvROW/m2HNFZFiWrj/
            # ZwucY/02aoH6KfjdK3CF3gIY83htvH35x20JPb5qdofpir34hF0edsnkxnZ2OlPR
            # 0dNaNo/Go+EvGzq3YdZz7E5tM4p8XUUtS7FQ5kE6N1aG3JMjjfdQJehk5t3Tjy9X
            # tYcg6w6OLNUj2vRNeEbjA4MxKUpcDDGKSoyIxfcwWvkUrxVfbENJCf0mI1P2jWPo
            # GqtbsR0wwptpgrTb/FZUvB+hh6u+elsKIC9LCcmVp42y+tZji06lchzun3oBc/gZ
            # 1v4NSYS9AQIDAQABo4IBuDCCAbQwDgYDVR0PAQH/BAQDAgeAMAwGA1UdEwEB/wQC
            # MAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwQQYDVR0gBDowODA2BglghkgBhv1s
            # BwEwKTAnBggrBgEFBQcCARYbaHR0cDovL3d3dy5kaWdpY2VydC5jb20vQ1BTMB8G
            # A1UdIwQYMBaAFPS24SAd/imu0uRhpbKiJbLIFzVuMB0GA1UdDgQWBBQ2RIaOpLqw
            # Zr68KC0dRDbd42p6vDBxBgNVHR8EajBoMDKgMKAuhixodHRwOi8vY3JsMy5kaWdp
            # Y2VydC5jb20vc2hhMi1hc3N1cmVkLXRzLmNybDAyoDCgLoYsaHR0cDovL2NybDQu
            # ZGlnaWNlcnQuY29tL3NoYTItYXNzdXJlZC10cy5jcmwwgYUGCCsGAQUFBwEBBHkw
            # dzAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tME8GCCsGAQUF
            # BzAChkNodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRTSEEyQXNz
            # dXJlZElEVGltZXN0YW1waW5nQ0EuY3J0MA0GCSqGSIb3DQEBCwUAA4IBAQBIHNy1
            # 6ZojvOca5yAOjmdG/UJyUXQKI0ejq5LSJcRwWb4UoOUngaVNFBUZB3nw0QTDhtk7
            # vf5EAmZN7WmkD/a4cM9i6PVRSnh5Nnont/PnUp+Tp+1DnnvntN1BIon7h6JGA078
            # 9P63ZHdjXyNSaYOC+hpT7ZDMjaEXcw3082U5cEvznNZ6e9oMvD0y0BvL9WH8dQgA
            # dryBDvjA4VzPxBFy5xtkSdgimnUVQvUtMjiB2vRgorq0Uvtc4GEkJU+y38kpqHND
            # Udq9Y9YfW5v3LhtPEx33Sg1xfpe39D+E68Hjo0mh+s6nv1bPull2YYlffqe0jmd4
            # +TaY4cso2luHpoovMIIFMDCCBBigAwIBAgIQBAkYG1/Vu2Z1U0O1b5VQCDANBgkq
            # hkiG9w0BAQsFADBlMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5j
            # MRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSQwIgYDVQQDExtEaWdpQ2VydCBB
            # c3N1cmVkIElEIFJvb3QgQ0EwHhcNMTMxMDIyMTIwMDAwWhcNMjgxMDIyMTIwMDAw
            # WjByMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQL
            # ExB3d3cuZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhEaWdpQ2VydCBTSEEyIEFzc3Vy
            # ZWQgSUQgQ29kZSBTaWduaW5nIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
            # CgKCAQEA+NOzHH8OEa9ndwfTCzFJGc/Q+0WZsTrbRPV/5aid2zLXcep2nQUut4/6
            # kkPApfmJ1DcZ17aq8JyGpdglrA55KDp+6dFn08b7KSfH03sjlOSRI5aQd4L5oYQj
            # ZhJUM1B0sSgmuyRpwsJS8hRniolF1C2ho+mILCCVrhxKhwjfDPXiTWAYvqrEsq5w
            # MWYzcT6scKKrzn/pfMuSoeU7MRzP6vIK5Fe7SrXpdOYr/mzLfnQ5Ng2Q7+S1TqSp
            # 6moKq4TzrGdOtcT3jNEgJSPrCGQ+UpbB8g8S9MWOD8Gi6CxR93O8vYWxYoNzQYIH
            # 5DiLanMg0A9kczyen6Yzqf0Z3yWT0QIDAQABo4IBzTCCAckwEgYDVR0TAQH/BAgw
            # BgEB/wIBADAOBgNVHQ8BAf8EBAMCAYYwEwYDVR0lBAwwCgYIKwYBBQUHAwMweQYI
            # KwYBBQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5j
            # b20wQwYIKwYBBQUHMAKGN2h0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdp
            # Q2VydEFzc3VyZWRJRFJvb3RDQS5jcnQwgYEGA1UdHwR6MHgwOqA4oDaGNGh0dHA6
            # Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcmww
            # OqA4oDaGNGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJ
            # RFJvb3RDQS5jcmwwTwYDVR0gBEgwRjA4BgpghkgBhv1sAAIEMCowKAYIKwYBBQUH
            # AgEWHGh0dHBzOi8vd3d3LmRpZ2ljZXJ0LmNvbS9DUFMwCgYIYIZIAYb9bAMwHQYD
            # VR0OBBYEFFrEuXsqCqOl6nEDwGD5LfZldQ5YMB8GA1UdIwQYMBaAFEXroq/0ksuC
            # MS1Ri6enIZ3zbcgPMA0GCSqGSIb3DQEBCwUAA4IBAQA+7A1aJLPzItEVyCx8JSl2
            # qB1dHC06GsTvMGHXfgtg/cM9D8Svi/3vKt8gVTew4fbRknUPUbRupY5a4l4kgU4Q
            # pO4/cY5jDhNLrddfRHnzNhQGivecRk5c/5CxGwcOkRX7uq+1UcKNJK4kxscnKqEp
            # KBo6cSgCPC6Ro8AlEeKcFEehemhor5unXCBc2XGxDI+7qPjFEmifz0DLQESlE/Dm
            # ZAwlCEIysjaKJAL+L3J+HNdJRZboWR3p+nRka7LrZkPas7CM1ekN3fYBIM6ZMWM9
            # CBoYs4GbT8aTEAb8B4H6i9r5gkn3Ym6hU/oSlBiFLpKR6mhsRDKyZqHnGKSaZFHv
            # MIIFMTCCBBmgAwIBAgIQCqEl1tYyG35B5AXaNpfCFTANBgkqhkiG9w0BAQsFADBl
            # MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3
            # d3cuZGlnaWNlcnQuY29tMSQwIgYDVQQDExtEaWdpQ2VydCBBc3N1cmVkIElEIFJv
            # b3QgQ0EwHhcNMTYwMTA3MTIwMDAwWhcNMzEwMTA3MTIwMDAwWjByMQswCQYDVQQG
            # EwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNl
            # cnQuY29tMTEwLwYDVQQDEyhEaWdpQ2VydCBTSEEyIEFzc3VyZWQgSUQgVGltZXN0
            # YW1waW5nIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvdAy7kvN
            # j3/dqbqCmcU5VChXtiNKxA4HRTNREH3Q+X1NaH7ntqD0jbOI5Je/YyGQmL8TvFfT
            # w+F+CNZqFAA49y4eO+7MpvYyWf5fZT/gm+vjRkcGGlV+Cyd+wKL1oODeIj8O/36V
            # +/OjuiI+GKwR5PCZA207hXwJ0+5dyJoLVOOoCXFr4M8iEA91z3FyTgqt30A6XLdR
            # 4aF5FMZNJCMwXbzsPGBqrC8HzP3w6kfZiFBe/WZuVmEnKYmEUeaC50ZQ/ZQqLKfk
            # dT66mA+Ef58xFNat1fJky3seBdCEGXIX8RcG7z3N1k3vBkL9olMqT4UdxB08r8/a
            # rBD13ays6Vb/kwIDAQABo4IBzjCCAcowHQYDVR0OBBYEFPS24SAd/imu0uRhpbKi
            # JbLIFzVuMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6enIZ3zbcgPMBIGA1UdEwEB
            # /wQIMAYBAf8CAQAwDgYDVR0PAQH/BAQDAgGGMBMGA1UdJQQMMAoGCCsGAQUFBwMI
            # MHkGCCsGAQUFBwEBBG0wazAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNl
            # cnQuY29tMEMGCCsGAQUFBzAChjdodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20v
            # RGlnaUNlcnRBc3N1cmVkSURSb290Q0EuY3J0MIGBBgNVHR8EejB4MDqgOKA2hjRo
            # dHRwOi8vY3JsNC5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURSb290Q0Eu
            # Y3JsMDqgOKA2hjRodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1
            # cmVkSURSb290Q0EuY3JsMFAGA1UdIARJMEcwOAYKYIZIAYb9bAACBDAqMCgGCCsG
            # AQUFBwIBFhxodHRwczovL3d3dy5kaWdpY2VydC5jb20vQ1BTMAsGCWCGSAGG/WwH
            # ATANBgkqhkiG9w0BAQsFAAOCAQEAcZUS6VGHVmnN793afKpjerN4zwY3QITvS4S/
            # ys8DAv3Fp8MOIEIsr3fzKx8MIVoqtwU0HWqumfgnoma/Capg33akOpMP+LLR2HwZ
            # YuhegiUexLoceywh4tZbLBQ1QwRostt1AuByx5jWPGTlH0gQGF+JOGFNYkYkh2OM
            # kVIsrymJ5Xgf1gsUpYDXEkdws3XVk4WTfraSZ/tTYYmo9WuWwPRYaQ18yAGxuSh1
            # t5ljhSKMYcp5lH5Z/IwP42+1ASa2bKXuh1Eh5Fhgm7oMLSttosR+u8QlK0cCCHxJ
            # rhO24XxCQijGGFbPQTS2Zl22dHv1VjMiLyI2skuiSpXY9aaOUjCCBTkwggQhoAMC
            # AQICEAq50xD7ISvojIGz0sLozlEwDQYJKoZIhvcNAQELBQAwcjELMAkGA1UEBhMC
            # VVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0
            # LmNvbTExMC8GA1UEAxMoRGlnaUNlcnQgU0hBMiBBc3N1cmVkIElEIENvZGUgU2ln
            # bmluZyBDQTAeFw0yMTA0MjcwMDAwMDBaFw0yNDA0MzAyMzU5NTlaMHcxCzAJBgNV
            # BAYTAlVTMQ8wDQYDVQQIEwZLYW5zYXMxDzANBgNVBAcTBlRvcGVrYTEiMCAGA1UE
            # ChMZQ2hvY29sYXRleSBTb2Z0d2FyZSwgSW5jLjEiMCAGA1UEAxMZQ2hvY29sYXRl
            # eSBTb2Z0d2FyZSwgSW5jLjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB
            # AKFxp42p47c7eHNsNhgxzG+/9A1I8Th+kj40YQJH4Vh0M7a61f39I/FELNYGuyCe
            # 0+z/sg+T+4VmT/JMiI2hc75yokTjkv3Yt1+fqABzCMadr+PZ/9ttIVJ5db3P2Uzc
            # Ml5wXBdCV5ZH/w4oKcP53VmYcHQEDm/RtAJ9TxlPtLS734oAqrKqBmsnJCI98FWp
            # d6z1FK5rv7RJVeZoGsl/2eMcB/ko0Vj9MSCbWvXNjDF9yy4Tl5h2vb+y7K1Qmk3X
            # yb0OYB1ibva9rQozGgogEa5DL0OdoMj6cyJ6Cx2GQv2wjKwiKfs9zCOTDH2VGa0i
            # okDbsd+BvUxovQ6eSnBFj5UCAwEAAaOCAcQwggHAMB8GA1UdIwQYMBaAFFrEuXsq
            # CqOl6nEDwGD5LfZldQ5YMB0GA1UdDgQWBBRO8wUYXZXrKVBqUW35p9FeNJoEgzAO
            # BgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwdwYDVR0fBHAwbjA1
            # oDOgMYYvaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL3NoYTItYXNzdXJlZC1jcy1n
            # MS5jcmwwNaAzoDGGL2h0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9zaGEyLWFzc3Vy
            # ZWQtY3MtZzEuY3JsMEsGA1UdIAREMEIwNgYJYIZIAYb9bAMBMCkwJwYIKwYBBQUH
            # AgEWG2h0dHA6Ly93d3cuZGlnaWNlcnQuY29tL0NQUzAIBgZngQwBBAEwgYQGCCsG
            # AQUFBwEBBHgwdjAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29t
            # ME4GCCsGAQUFBzAChkJodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNl
            # cnRTSEEyQXNzdXJlZElEQ29kZVNpZ25pbmdDQS5jcnQwDAYDVR0TAQH/BAIwADAN
            # BgkqhkiG9w0BAQsFAAOCAQEAoXGdwcDMMV6xQldozbWoxGTn6chlwO4hJ8aAlwOM
            # wexEvDudrlifsiGI1j46wqc9WR8+Ev8w1dIcbqif4inGIHb8GvL22Goq+lB08F7y
            # YU3Ry0kOCtJx7JELlID0SI7bYndg17TJUQoAb5iTYD9aEoHMIKlGyQyVGvsp4ubo
            # O8CC8Owx+Qq148yXY+to4360U2lzZvUtMpPiiSJTm4BamNgC32xgGwpN5lvk0m3R
            # lDdqQQQgBCzrf+ZIMBmXMw4kxY0r/K/g1TkKI9VyiEnRaNQlQisAyYBWVnaHw2EJ
            # ck6/bxwdYSA+Sz/Op0N0iEl8MX4At3XQlMGvAI1xhAbrwDGCBG0wggRpAgEBMIGG
            # MHIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsT
            # EHd3dy5kaWdpY2VydC5jb20xMTAvBgNVBAMTKERpZ2lDZXJ0IFNIQTIgQXNzdXJl
            # ZCBJRCBDb2RlIFNpZ25pbmcgQ0ECEAq50xD7ISvojIGz0sLozlEwDQYJYIZIAWUD
            # BAIBBQCggYQwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMx
            # DAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkq
            # hkiG9w0BCQQxIgQgey25OsHafMX1HWLKRJb0Sf/lMMX5vF0EAhjyQlfUDzgwDQYJ
            # KoZIhvcNAQEBBQAEggEAC0wtyHWaoYbiMY8PXKaNf16zoeuj5jYAuvx0B/nzJ27A
            # tP/Mo9SC1Z4M2iEps/LDScRoy3N8pCI8NQBDjWGGkjW5ScFvF7a042DcurR+LE30
            # aa4d7Y0MT8O+vhQDcVCmB7JB+9E6/7+qpD1vVfs1zYw1cprCZoOejttDCEvlvsAN
            # VrPKixhxbLcLu/5KV9qUBUWW9vEz8/WL1IcNcsfwd61+JWa116CXeyoLKqWXJIPF
            # uNnULZTs/E2BY1JYBKIfzvSi3QWg/uWvJucdGdbLib4d1gEXxLtHk+aDOLTXRG12
            # yjMdCF1FhyeC+hyWSgwyXZ0V9zRGpiS+IjarelHVDqGCAjAwggIsBgkqhkiG9w0B
            # CQYxggIdMIICGQIBATCBhjByMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNl
            # cnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhEaWdp
            # Q2VydCBTSEEyIEFzc3VyZWQgSUQgVGltZXN0YW1waW5nIENBAhANQkrgvjqI/2BA
            # Ic4UAPDdMA0GCWCGSAFlAwQCAQUAoGkwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
            # ATAcBgkqhkiG9w0BCQUxDxcNMjEwNjE3MDg0MjQzWjAvBgkqhkiG9w0BCQQxIgQg
            # Osdf/2XOopSIGgniCq9vRS6UGDVJ7TingAmrcmwYcWowDQYJKoZIhvcNAQEBBQAE
            # ggEAs50N1tQOpzvCCO9R4hCcaMY0jsOm7QOOk257yySmEFbtgmKUpNmyyfwK0Wl/
            # Ti1IOTOQ1oz7Wz6Q/kEgPoZAbuAhXKH+At6Vwa98Jp3GG6abokNohPI3cWGJbS3u
            # rJEKZay3+1fGNaYOCpIqkhpnVqyTNoLlNBLcGOkq7FgBKsomtQSO9ejFluS1woKY
            # wK7EiXjzDwFG18DmnUuRpO4xrdmcbh7m3MnC95DjYcFFzKr/xxideicJAGZSHOo1
            # nQorVQyPcXQe4Nl2JHAr3R6RTeaXgq6We4LSdMsO5BAyduh/w4nicahwAv5wgIsw
            # cUvCYQiMMXCU2x9vsn8B5wKETQ==
            # SIG # End signature block
'@
            Set-ExecutionPolicy Unrestricted -Scope Process -Force; Invoke-Expression `
                $choco
        }
        If ($Chrome.IsChecked) {
            choco install googlechrome -y
        }
        If ($Firefox.IsChecked) {
            choco install firefox -y
        }
        If ($Zoom.IsChecked) {
            choco install zoom -y
        }
        If ($Teams.IsChecked) {
            choco install Teams -y
        }
        If ($WinRAR.IsChecked) {
            choco install WinRAR -y
        }
        If ($_7Zip.IsChecked) {
            choco install _7Zip -y
        }
        If ($AppB3.IsChecked) {
        }
        If ($AppB4.IsChecked) {
        }
    })
$window.ShowDialog() | Out-Null