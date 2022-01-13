function Import-Xaml {
    #Import Xaml for MainWindow
    [System.Reflection.Assembly]::LoadWithPartialName("PresentationFramework") | Out-Null
    [xml]$xaml = Get-Content -Path "$PSScriptRoot\PowerSetupWPF.xaml"
    $manager = New-Object System.Xml.XmlNamespaceManager -ArgumentList $xaml.NameTable
    $manager.AddNamespace("x", "http://schemas.microsoft.com/winfx/2006/xaml");
    $xamlReader = (New-Object System.Xml.XmlNodeReader $xaml)
    [Windows.Markup.XamlReader]::Load($xamlReader)
}
function PowerLangSetup {
    #Set Language, region, and keyboard languages
    Set-Culture en-US
    Set-WinUILanguageOverride -Language en-US
    Set-WinUserLanguageList en-US, el-GR -Force
    Set-WinHomeLocation -GeoId 98
    Set-WinSystemLocale -SystemLocale el-GR #On next boot
}
function PowerNetSetup {
    #Enable firewall rule for Remote Desktop - User Mode (TCP & UDP)
    Get-NetFirewallRule -DisplayName "Remote Desktop - User*" | Set-NetFirewallRule -Enabled true

    #Enable firewall rule for Remote Desktop - User Mode (TCP & UDP) (Greek Firewall Rules)
    Get-NetFirewallRule -DisplayName "Απομακρυσμένη επιφάνεια εργασίας - Λειτουργία χρήστη*" | Set-NetFirewallRule -Enabled true
}
function PowerProxySetup {
    #Disable Automatically Detect proxy settings
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" AutoDetect 0
}
function PowerTimeSetup {
    #Set timezone to Athens 
    Set-TimeZone "GTB Standard Time"
}
function PowerExplorerSetup {
    $WinExpPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer"
    $WinExpPathAdv = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    $PolWinExp = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
    #Show Frequent files
    Set-ItemProperty -Path $WinExpPath ShowFrequent 0
    #Show Recent files
    Set-ItemProperty -Path $WinExpPath ShowRecent 0 
    #Show File Extensions
    Set-ItemProperty -Path $WinExpPathAdv HideFileExt 0
    #Hide Cortana buttons
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
    Stop-Process -processname explorer -ErrorAction SilentlyContinue
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
    #Stop-Process -processname explorer -ErrorAction SilentlyContinue
}
function PowerPlanSetup {
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
function PowerAppRemove {
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
    Remove-Item -Path $env:ChocolateyInstall -Recurse -Force
    'ChocolateyInstall', 'ChocolateyLastPathUpdate' | ForEach-Object {
        foreach ($scope in 'User', 'Machine') {
            [Environment]::SetEnvironmentVariable($_, [string]::Empty, $scope)
        }
    }    
    #Clear Temp in Appdata
    Remove-Item -Path $env:LOCALAPPDATA\Temp\* -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $env:LOCALAPPDATA\NuGet -Recurse -Force -ErrorAction SilentlyContinue
}
function Remove-WriteHost {
    # Remove WriteHost Messages
    [CmdletBinding(DefaultParameterSetName = 'FromPipeline')]
    param(
        [Parameter(ValueFromPipeline = $true, ParameterSetName = 'FromPipeline')]
        [object] $InputObject,
 
        [Parameter(Mandatory = $true, ParameterSetName = 'FromScriptblock', Position = 0)]
        [ScriptBlock] $ScriptBlock
    )
 
    begin {
        function Cleanup {
            Remove-Item function:\write-host -ea 0
        }
 
        function ReplaceWriteHost([string] $Scope) {
            Invoke-Expression "function ${scope}:Write-Host { }"
        }
        Cleanup
        if ($pscmdlet.ParameterSetName -eq 'FromPipeline') {
            ReplaceWriteHost -Scope 'global'
        }
    }
}
function progCounter {
    #Progress Bar Counter
    $ProgressBar.value += 1
    Update-Gui
}
function DisableWpf {
    $PowerExplorerSetup.IsEnabled = $false
    $PowerAppRemove.IsEnabled = $false
    $PowerLangSetup.IsEnabled = $false
    $PowerNetSetup.IsEnabled = $false
    $PowerProxySetup.IsEnabled = $false
    $PowerTimeSetup.IsEnabled = $false
    $PowerPlanSetup.IsEnabled = $false
    $PowerDisplayTimer.IsEnabled = $false
    $PowerComputerTimer.IsEnabled = $false
    $Chrome.IsEnabled = $false
    $Firefox.IsEnabled = $false
    $Zoom.IsEnabled = $false
    $Teams.IsEnabled = $false
    $WinRAR.IsEnabled = $false
    $_7Zip.IsEnabled = $false
    $VLC.IsEnabled = $false
    $AnyDesk.IsEnabled = $false
    $Team_Viewer.IsEnabled = $false
    $ACReader.IsEnabled = $false
    $PuTTY.IsEnabled = $false
    $FileZilla.IsEnabled = $false
    $VSCode.IsEnabled = $false
    $HDV.IsEnabled = $false
    $TXViewer.IsEnabled = $false
    $iNews.IsEnabled = $false
    $RunButton.IsEnabled = $false
    $DomainButton.IsEnabled = $false
    $AdminButton.IsEnabled = $false
    $PowerSettings.IsEnabled = $false
    $AppSetup.IsEnabled = $false
}
#Build the GUI
$window = Import-Xaml
# XAML objects
# Windows Settings Checkboxes
$PowerExplorerSetup = $window.FindName("PowerExplorerSetup")
$PowerAppRemove = $window.FindName("PowerAppRemove")
$PowerLangSetup = $Window.FindName("PowerLangSetup")
$PowerNetSetup = $Window.FindName("PowerNetSetup")
$PowerProxySetup = $Window.FindName("PowerProxySetup")
$PowerTimeSetup = $Window.FindName("PowerTimeSetup")

$PowerPlanSetup = $Window.FindName("PowerPlanSetup")
$PowerDisplayTimer = $Window.FindName("PowerDisplayTimer")
$PowerComputerTimer = $Window.FindName("PowerComputerTimer")
#$Option4 = $Window.FindName("Option4")
#$Option5 = $Window.FindName("Option5")
#$Option6 = $Window.FindName("Option6")
# Application Setup Checkboxes
$Chrome = $Window.FindName("Chrome")
$Firefox = $Window.FindName("Firefox")
$Zoom = $Window.FindName("Zoom")
$Teams = $Window.FindName("Teams")

$WinRAR = $window.FindName("WinRAR")
$_7Zip = $Window.FindName("_7Zip")
$VLC = $Window.FindName("VLC")
#$AppB4 = $Window.FindName("AppB4")

$AnyDesk = $Window.FindName("AnyDesk")
$Team_Viewer = $Window.FindName("Team_Viewer")
#$AppC3 = $Window.FindName("AppC3")
#$AppC4 = $Window.FindName("AppC4")

$ACReader = $Window.FindName("ACReader")
$PuTTY = $Window.FindName("PuTTY")
$FileZilla = $Window.FindName("FileZilla")
$VSCode = $Window.FindName("VSCode")

$HDV = $Window.FindName("HDV")
$TXViewer = $Window.FindName("TXViewer")

$iNews = $Window.FindName("iNews")
# Progress Bar
$ProgressBar = $Window.FindName("Progress")
# Buttons
$RunButton = $Window.FindName("RunButton")
$DomainButton = $Window.FindName("DomainButton")
$AdminButton = $Window.FindName("AdminButton")
$PowerSettings = $Window.FindName("PowerSettings")
$AppSetup = $Window.FindName("AppSetup")
# Labels
$status = $Window.FindName("StatusLBL")
# Tabs
$LocalTab = $Window.FindName("LocalTab")

#Condition for local installations
if (Test-Path PowerSetup.json) {
    $LocalTab.Visibility = "Visible"
}
# Hide Progress Prompts
$ProgressPreference = 'SilentlyContinue'
# Click Actions
$PowerSettings.Add_Click({
        $PowerLangSetup.IsChecked = (-not $PowerLangSetup.IsChecked)
        $PowerNetSetup.IsChecked = (-not $PowerNetSetup.IsChecked)
        $PowerProxySetup.IsChecked = (-not $PowerProxySetup.IsChecked)
        $PowerTimeSetup.IsChecked = (-not $PowerTimeSetup.IsChecked)
        $PowerExplorerSetup.IsChecked = (-not $PowerExplorerSetup.IsChecked)
        $PowerPlanSetup.IsChecked = (-not $PowerPlanSetup.IsChecked)
        $PowerDisplayTimer.IsChecked = (-not $PowerDisplayTimer.IsChecked)
        $PowerComputerTimer.IsChecked = (-not $PowerComputerTimer.IsChecked)
        $PowerAppRemove.IsChecked = (-not $PowerAppRemove.IsChecked)
    })
$AppSetup.Add_Click({
        $Chrome.IsChecked = (-not $Chrome.IsChecked)
        $Firefox.IsChecked = (-not $Firefox.IsChecked)
        $WinRAR.IsChecked = (-not $WinRAR.IsChecked)
        $VLC.IsChecked = (-not $VLC.IsChecked)
    })
$DomainButton.Add_Click({ 
        $Serial = Get-WmiObject -Class "Win32_BIOS" | Select-Object -Expand SerialNumber
        $NewComputerName = (Read-Host -Prompt "Set Computer Name (with serial number: $Serial)") 
        $domain = (Read-Host -Prompt "        Enter domain name") 
        #$username = "USERNAME"
        #$password = "PASSWORD" | ConvertTo-SecureString -AsPlainText -Force
        #$Credential = New-Object System.Management.Automation.PSCredential($username,$password)
        Rename-Computer -NewName $NewComputerName 
        Add-Computer -DomainName $domain -Credential $domain\ -Options JoinWithNewName -Force
    })
$AdminButton.Add_Click({
        Update-Gui
        $Password = (Read-Host -Prompt "Set password for the Administrator account" -AsSecureString)
        $UserAccount = Get-LocalUser -Name "Administrator"
        $UserAccount | Set-LocalUser -Password $Password
        C:\WINDOWS\system32\net.exe user administrator /active:yes
    })
$RunButton.Add_Click({
        Update-Gui
        DisableWpf
        Remove-WriteHost
        $RunButton.Visibility = "hidden"
        Update-Gui
        $ProgressBar.Visibility = "Visible"
        Update-Gui
        $status.Visibility = "Visible"
        Update-Gui
        If ($PowerLangSetup.IsChecked) { 
            Update-Gui
            $status.Content = "Setting Language, region, and keyboard languages... "
            PowerLangSetup
            #$PowerLangSetup.IsChecked = $false
        }
        progCounter
        If ($PowerNetSetup.IsChecked) { 
            Update-Gui
            $status.Content = "Enabling firewall rule for Remote Desktop ... "
            PowerNetSetup
            #$PowerNetSetup.IsChecked = $false
        }
        progCounter
        If ($PowerProxySetup.IsChecked) {
            Update-Gui
            $status.Content = "Disabling proxy... "
            PowerProxySetup
            #$PowerProxySetup.IsChecked = $false
        }
        If ($PowerTimeSetup.IsChecked) {
            Update-Gui
            $status.Content = "Setting time and timezone... "
            PowerTimeSetup
            #$PowerTimeSetup.IsChecked = $false
        }
        progCounter
        If ($PowerExplorerSetup.IsChecked ) {
            Update-Gui
            $status.Content = "Setting Windows Explorer and Taskbar settings... "
            PowerExplorerSetup
            #$PowerExplorerSetup.IsChecked = $false
        }
        progCounter
        If ($PowerPlanSetup.IsChecked -and $env:UserName -ne "WDAGUtilityAccount" ) {
            Update-Gui
            $status.Content = "Setting active power plan to High Performance... "
            PowerPlanSetup
            #$PowerPlanSetup.IsChecked = $false
        }
        progCounter
        If ($PowerDisplayTimer.IsChecked -and $env:UserName -ne "WDAGUtilityAccount") {
            Update-Gui
            $status.Content = "Turning off display timer... "
            PowerDisplayTimer
            #$PowerDisplayTimer.IsChecked = $false
        }
        progCounter
        If ($PowerComputerTimer.IsChecked -and $env:UserName -ne "WDAGUtilityAccount") {
            Update-Gui
            $status.Content = "Turning off computer sleep timer... "
            PowerComputerTimer
            #$PowerComputerTimer.IsChecked = $false
        }
        progCounter
        If ($PowerAppRemove.IsChecked) {
            Update-Gui
            $status.Content = "Removing Windows Store apps... "
            PowerAppRemove
            #$PowerAppRemove.IsChecked = $false
        }
        progCounter
        If ($Chrome.IsChecked -or $Firefox.IsChecked -or $Zoom.IsChecked -or $Teams.IsChecked -or $WinRAR.IsChecked -or $_7Zip.IsChecked -or $VLC.IsChecked -or $AnyDesk.IsChecked -or $Team_Viewer.IsChecked -or $ACReader.IsChecked -or $PuTTY.IsChecked -or $FileZilla.IsChecked -or $VSCode.IsChecked) {
            Update-Gui
            $status.Content = " Preparing to install applications... "
            Update-Gui
            ChocoInstall
        }
        progCounter
        If ($Chrome.IsChecked) {
            Update-Gui
            $status.Content = " Installing Google Chrome... "
            Update-Gui
            choco install googlechrome -y
            #$Chrome.IsChecked = $false
        }
        progCounter
        If ($Firefox.IsChecked) {
            Update-Gui
            $status.Content = " Installing Firefox... "
            Update-Gui
            choco install firefox -y
            #$Firefox.IsChecked = $false
        }
        progCounter
        If ($Zoom.IsChecked) {
            Update-Gui
            $status.Content = " Installing Zoom... "
            Update-Gui
            choco install zoom -y
            #$Zoom.IsChecked = $false
        }
        progCounter
        If ($Teams.IsChecked) {
            Update-Gui
            $status.Content = " Installing Microsoft Teams... "
            Update-Gui
            choco install microsoft-teams.install -y
            #$Teams.IsChecked = $false
        }
        progCounter
        If ($WinRAR.IsChecked) {
            Update-Gui
            $status.Content = " Installing WinRAR... "
            Update-Gui
            choco install WinRAR -y
            #$WinRAR.IsChecked = $false
        }
        progCounter
        If ($_7Zip.IsChecked) {
            Update-Gui
            $status.Content = " Installing 7Zip... "
            Update-Gui
            choco install 7Zip -y
            #$_7Zip.IsChecked = $false
        }
        progCounter
        If ($VLC.IsChecked) {
            Update-Gui
            $status.Content = " Installing VLC... "
            Update-Gui
            choco install vlc -y
            #$VLC.IsChecked = $false
        }
        progCounter
        If ($AnyDesk.IsChecked) {
            Update-Gui
            $status.Content = " Installing AnyDesk... "
            Update-Gui
            choco install anydesk.install -y
            #$AnyDesk.IsChecked = $false
        }
        progCounter
        If ($Team_Viewer.IsChecked) {
            Update-Gui
            $status.Content = " Installing Team Viewer... "
            Update-Gui
            choco install teamviewer -y
            #$Team_Viewer.IsChecked = $false
        }
        progCounter
        If ($ACReader.IsChecked) {
            Update-Gui
            $status.Content = " Installing Adobe Acrobat Reader DC... "
            Update-Gui
            choco install adobereader -y
            #$ACReader.IsChecked = $false
        }
        progCounter
        If ($PuTTY.IsChecked) {
            Update-Gui
            $status.Content = " Installing PuTTY... "
            Update-Gui
            choco install putty -y
            #$PuTTY.IsChecked = $false
        }
        progCounter
        If ($FileZilla.IsChecked) {
            Update-Gui
            $status.Content = " Installing Filezilla... "
            Update-Gui
            choco install filezilla -y
            #$FileZilla.IsChecked = $false
        }
        progCounter
        If ($VSCode.IsChecked) {
            Update-Gui
            $status.Content = " Installing Visual Studio Code... "
            Update-Gui
            choco install vscode -y
            #$VSCode.IsChecked = $false
        }
        progCounter
        If (Test-Path -Path "$env:ProgramData\Chocolatey") {
            Update-Gui
            $status.Content = " Cleaning Up... "
            Update-Gui
            ChocoRemove
        }
        progCounter
        If ($HDV.IsChecked -or $TXViewer.IsChecked -or $iNews.IsChecked) {
            $location = Get-Content -Path PowerSetup.json | ConvertFrom-Json
        }
        If ($HDV.IsChecked) {
            Update-Gui
            $status.Content = " Installing HD Viewer... "
            Update-Gui
            Start-Process -PassThru -FilePath "$env:systemroot\system32\msiexec.exe" -ArgumentList "/i `"$($location.HDV)`" /q" -Wait
            #$HDV.IsChecked = $false
        }
        progCounter
        If ($TXViewer.IsChecked) {
            Update-Gui
            $status.Content = " Installing TX Viewer... "
            Update-Gui
            Start-Process -PassThru -FilePath "$env:systemroot\system32\msiexec.exe" -ArgumentList "/i `"$($location.TXViewer)`" /q" -Wait
            #$TXViewer.IsChecked = $false
        }
        If ($iNews.IsChecked) {
            Update-Gui
            $status.Content = " Installing iNews... "
            Update-Gui
            Start-Process -PassThru `"$($location.iNews)`" -NoNewWindow -Wait
        }
        progCounter
        $status.Content = " Setup Complete! "
        $ProgressPreference = 'Continue'
    })
Function Update-Gui() {
    #$Window.Dispatcher.Invoke([Action] {}, [Windows.Threading.DispatcherPriority]::ContextIdle);
    $Window.Dispatcher.Invoke([Windows.Threading.DispatcherPriority]::Background, [action] {})
}
$Window.Add_ContentRendered({
        Update-Gui
    })
$window.ShowDialog() | Out-Null