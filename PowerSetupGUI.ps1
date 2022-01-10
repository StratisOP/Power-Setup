# Hide console
$SW_HIDE, $SW_SHOW = 0, 5
$TypeDef = '[DllImport("User32.dll")]public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);'
Add-Type -MemberDefinition $TypeDef -Namespace Win32 -Name Functions
$hWnd = (Get-Process -Id $PID).MainWindowHandle
$Null = [Win32.Functions]::ShowWindow($hWnd, $SW_HIDE)
# Hide Progress Prompts
$ProgressPreference = 'SilentlyContinue'
#Build the GUI
Add-Type -AssemblyName PresentationFramework
[xml]$xaml = @'
<Window x:Name="Window"
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
    xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
    xmlns:local="clr-namespace:WinSetupGUI"
    Title="Power Setup" Height="400" Width="600"
    ResizeMode="CanMinimize" WindowStartupLocation="CenterScreen">
    <Grid Margin="25,40,25,10">
        <Grid.RowDefinitions>
            <RowDefinition Height="71*" />
            <RowDefinition Height="60*" />
            <RowDefinition Height="25*"/>
        </Grid.RowDefinitions>

        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="150*" />
            <ColumnDefinition Width="150*"/>
            <ColumnDefinition Width="150*" />
            <ColumnDefinition Width="150*"/>
        </Grid.ColumnDefinitions>
        <Button x:Name="PowerSettings" Content="Windows Settings" HorizontalAlignment="Left" Margin="-72,45,0,0" VerticalAlignment="Top" Width="115" Height="25" Visibility="Visible" RenderTransformOrigin="0.5,0.5" Background="{x:Null}" BorderBrush="{x:Null}" >
            <Button.RenderTransform>
                <TransformGroup>
                    <ScaleTransform/>
                    <SkewTransform/>
                    <RotateTransform Angle="90"/>
                    <TranslateTransform/>
                </TransformGroup>
            </Button.RenderTransform>
        </Button>
        <Button x:Name="AppSetup" Content="Application Setup" HorizontalAlignment="Left" Margin="-72,43,0,0" VerticalAlignment="Top" Width="115" Height="25" Visibility="Visible" RenderTransformOrigin="0.5,0.5" Background="{x:Null}" Grid.Row="1" BorderBrush="{x:Null}" >
            <Button.RenderTransform>
                <TransformGroup>
                    <ScaleTransform/>
                    <SkewTransform/>
                    <RotateTransform Angle="90"/>
                    <TranslateTransform/>
                </TransformGroup>
            </Button.RenderTransform>
        </Button>

        <CheckBox x:Name="PowerExplorerSetup" Content="Setup Explorer and Taskbar" HorizontalAlignment="Left" Grid.Row="0" VerticalAlignment="Top" IsChecked="False" Height="15" Width="166" Grid.ColumnSpan="2"/>
        <CheckBox x:Name="PowerAppRemove" Content="Remove Built in Windows apps" HorizontalAlignment="Left" Grid.Row="0" VerticalAlignment="Top" IsChecked="False" Margin="0,20,0,0" Height="15" Width="187" Grid.ColumnSpan="2"/>
        <CheckBox x:Name="PowerLangSetup" Content="Set Language, Region and Keyboard" HorizontalAlignment="Left" Grid.Row="0" VerticalAlignment="Top" IsChecked="False" Margin="0,40,0,0" Height="15" Width="214" Grid.ColumnSpan="2"/>
        <CheckBox x:Name="PowerNetSetup" Content="Enable firewall rule for Remote Desktop" HorizontalAlignment="Left" VerticalAlignment="Top" IsChecked="False" Height="15" Width="232" Grid.ColumnSpan="2" Margin="0,61,0,0"/>
        <CheckBox x:Name="PowerProxySetup" Content="Disable Automatically Detect proxy settings" HorizontalAlignment="Left" Grid.Row="0" VerticalAlignment="Top" IsChecked="False" Margin="0,80,0,0" Height="15" Width="253" Grid.ColumnSpan="2"/>
        <CheckBox x:Name="PowerTimeSetup" Content="Set time and timezone automatically" HorizontalAlignment="Left" Grid.Row="0" VerticalAlignment="Top" Margin="0,100,0,0" Height="15" Width="214" IsChecked="False" Grid.ColumnSpan="2"/>

        <CheckBox x:Name="PowerPlanSetup" Content="Set High Perfomance power plan" HorizontalAlignment="Left" Grid.Row="0" VerticalAlignment="Top" Grid.Column="2" IsChecked="False" Height="15" Width="197" Grid.ColumnSpan="2"/>
        <CheckBox x:Name="PowerDisplayTimer" Content="Disable turn off display timer" HorizontalAlignment="Left" Grid.Row="0" VerticalAlignment="Top" Grid.Column="2" IsChecked="False" Margin="0,20,0,0" Height="15" Width="175" Grid.ColumnSpan="2"/>
        <CheckBox x:Name="PowerComputerTimer" Content="Disable Computer sleep timer" HorizontalAlignment="Left" Grid.Row="0" VerticalAlignment="Top" Grid.Column="2" IsChecked="False" Margin="0,40,0,0" Height="15" Width="183" Grid.ColumnSpan="2"/>
        <CheckBox x:Name="Option4" Content="Option4" HorizontalAlignment="Left" VerticalAlignment="Center" Grid.Column="2" Height="15" Width="67" Visibility="Hidden"/>
        <CheckBox Content="Option5" HorizontalAlignment="Left" Grid.Row="0" VerticalAlignment="Top" Grid.Column="2" Margin="0,80,0,0" Height="15" Width="67" Visibility="Hidden"/>
        <CheckBox Content="Option6" HorizontalAlignment="Left" Grid.Row="0" VerticalAlignment="Top" Grid.Column="2" Margin="0,100,0,0" Height="15" Width="67" Visibility="Hidden"/>

        <Button x:Name="RunButton" Content="Run..." HorizontalAlignment="Center" Grid.Row="2" VerticalAlignment="Center" Height="38" Width="86" FontSize="14" IsDefault="True" IsEnabled="True" Grid.ColumnSpan="2" Grid.Column="1" Visibility="Visible"/>
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
        <ProgressBar x:Name="Progress" HorizontalAlignment="Center" Height="33" VerticalAlignment="Center" Width="548" Grid.Row="2" Grid.ColumnSpan="4" Value="0" IsEnabled="False" Visibility="Collapsed" Minimum="1" Maximum="30"/>
        <Label x:Name="StatusLBL" Content="Starting..." HorizontalAlignment="Left" HorizontalContentAlignment="Center" VerticalAlignment="Top" Grid.ColumnSpan="4" Width="500" Height="33" Margin="24,11,0,0" Grid.Row="2" Visibility="Collapsed"/>
        <Button x:Name="DomainButton" Content="Add to Domain..." HorizontalAlignment="Left" Margin="0,-37,0,0" VerticalAlignment="Top" Width="130" Height="27" Grid.Column="2" Visibility="Visible" />
        <Button x:Name="AdminButton" Content="Set Admin Account..." HorizontalAlignment="Left" Margin="0,-37,0,0" VerticalAlignment="Top" Width="130" Height="27" Grid.Column="3" Visibility="Visible"/>
        <TabControl x:Name="ApplicationSetup" Grid.ColumnSpan="4" Margin="0,126,0,10" Grid.RowSpan="2">
            <TabItem x:Name="OnlineTab" Header="Online" Visibility="Visible">
                <Grid Background="#FFE5E5E5">
                    <CheckBox x:Name="Chrome" Content="Chrome" HorizontalAlignment="Left" VerticalAlignment="Top" IsChecked="False" Margin="4,10,0,0" Height="15" Width="64"/>
                    <CheckBox x:Name="Firefox" Content="Firefox" HorizontalAlignment="Left" VerticalAlignment="Top" IsChecked="False" Margin="4,31,0,0" Height="15" Width="58"/>
                    <CheckBox x:Name="Zoom" Content="Zoom" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="4,51,0,0" Height="15" Width="51" IsChecked="False"/>
                    <CheckBox x:Name="Teams" Content="Teams" HorizontalAlignment="Left" Margin="4,72,0,0" Height="15" Width="58" VerticalAlignment="Top"/>
                    <CheckBox x:Name="WinRAR" Content="WinRAR" HorizontalAlignment="Left" VerticalAlignment="Top" IsChecked="False" Margin="147,10,0,0" Height="15" Width="62"/>
                    <CheckBox x:Name="_7Zip" Content="7zip" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="147,31,0,0" Height="15" Width="43" />
                    <CheckBox x:Name="VLC" Content="VLC" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="147,51,0,0" Height="15" Width="43" IsChecked="False"/>
                    <CheckBox Content="AppB4" HorizontalAlignment="Right" Margin="0,72,272,0" Height="15" Width="125" VerticalAlignment="Top" Visibility="Hidden" />
                    <CheckBox x:Name="AnyDesk" Content="AnyDesk" HorizontalAlignment="Left" VerticalAlignment="Top" IsChecked="False" Margin="272,10,0,0" Height="15" Width="67"/>
                    <CheckBox x:Name="Team_Viewer" Content="Team Viewer" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="272,31,0,0" Height="15" Width="88"/>
                    <CheckBox Content="AppC3" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="272,51,0,0" Height="15" Width="135" Visibility="Hidden"/>
                    <CheckBox Content="AppC4" HorizontalAlignment="Left" Margin="272,72,0,0" Height="15" Width="135" VerticalAlignment="Top" Visibility="Hidden"/>
                    <CheckBox x:Name="ACReader" Content="Acrobat Reader" HorizontalAlignment="Left" VerticalAlignment="Top" IsChecked="False" Margin="407,10,0,0" Height="15" Width="125"/>
                    <CheckBox x:Name="PuTTY" Content="PuTTY" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="407,31,0,0" Height="15" Width="53"/>
                    <CheckBox x:Name="FileZilla" Content="FileZilla" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="407,51,0,0" Height="15" Width="63"/>
                    <CheckBox x:Name="VSCode" Content="VS Code" HorizontalAlignment="Left" Margin="407,72,0,0" Height="15" Width="125" VerticalAlignment="Top"/>
                </Grid>
            </TabItem>
            <TabItem x:Name="LocalTab" Header="Local" Visibility="Collapsed">
                <Grid Background="#FFE5E5E5">
                    <CheckBox x:Name="HDV" Content="HDV" HorizontalAlignment="Left" VerticalAlignment="Top" IsChecked="False" Margin="4,10,0,0" Height="15" Width="44"/>
                    <CheckBox x:Name="TXViewer" Content="TXViewer" HorizontalAlignment="Left" VerticalAlignment="Top" IsChecked="False" Margin="4,31,0,0" Height="15" Width="73"/>
                </Grid>
            </TabItem>
        </TabControl>
    </Grid>
</Window>
'@
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)
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
    #Set time automatically
    Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters Type NTP
    #Set timezone automatically 
    Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate Start 3
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
            remove-item function:\write-host -ea 0
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
    Countdown
}
function DisableWpf {
    $PowerExplorerSetup.IsEnabled= $false
    $PowerAppRemove.IsEnabled= $false
    $PowerLangSetup.IsEnabled= $false
    $PowerNetSetup.IsEnabled= $false
    $PowerProxySetup.IsEnabled= $false
    $PowerTimeSetup.IsEnabled= $false
    $PowerPlanSetup.IsEnabled= $false
    $PowerDisplayTimer.IsEnabled= $false
    $PowerComputerTimer.IsEnabled= $false
    $Option4.IsEnabled= $false
    $Option5.IsEnabled= $false
    $Option6.IsEnabled= $false
    $Chrome.IsEnabled= $false
    $Firefox.IsEnabled= $false
    $Zoom.IsEnabled= $false
    $Teams.IsEnabled= $false
    $WinRAR.IsEnabled= $false
    $_7Zip.IsEnabled= $false
    $VLC.IsEnabled= $false
    $AppB4.IsEnabled= $false
    $AnyDesk.IsEnabled= $false
    $Team_Viewer.IsEnabled= $false
    $AppC3.IsEnabled= $false
    $AppC4.IsEnabled= $false
    $ACReader.IsEnabled= $false
    $PuTTY.IsEnabled= $false
    $FileZilla.IsEnabled= $false
    $VSCode.IsEnabled= $false
    $HDV.IsEnabled= $false
    $TXViewer.IsEnabled= $false
    $RunButton.IsEnabled= $false
    $DomainButton.IsEnabled= $false
    $AdminButton.IsEnabled= $false
    $PowerSettings.IsEnabled= $false
    $AppSetup.IsEnabled= $false
}
# XAML objects
# Windows Settings Checkboxes
#Grid A
$PowerExplorerSetup = $window.FindName("PowerExplorerSetup")
$PowerAppRemove = $window.FindName("PowerAppRemove")
$PowerLangSetup = $Window.FindName("PowerLangSetup")
$PowerNetSetup = $Window.FindName("PowerNetSetup")
$PowerProxySetup = $Window.FindName("PowerProxySetup")
$PowerTimeSetup = $Window.FindName("PowerTimeSetup")
#Grid B
$PowerPlanSetup = $Window.FindName("PowerPlanSetup")
$PowerDisplayTimer = $Window.FindName("PowerDisplayTimer")
$PowerComputerTimer = $Window.FindName("PowerComputerTimer")
$Option4 = $Window.FindName("Option4")
$Option5 = $Window.FindName("Option5")
$Option6 = $Window.FindName("Option6")
# Application Setup Checkboxes
#Grid A
$Chrome = $Window.FindName("Chrome")
$Firefox = $Window.FindName("Firefox")
$Zoom = $Window.FindName("Zoom")
$Teams = $Window.FindName("Teams")
#Grid B
$WinRAR = $window.FindName("WinRAR")
$_7Zip = $Window.FindName("_7Zip")
$VLC = $Window.FindName("VLC")
$AppB4 = $Window.FindName("AppB4")
#Grid C
$AnyDesk = $Window.FindName("AnyDesk")
$Team_Viewer = $Window.FindName("Team_Viewer")
$AppC3 = $Window.FindName("AppC3")
$AppC4 = $Window.FindName("AppC4")
#Grid D
$ACReader = $Window.FindName("ACReader")
$PuTTY = $Window.FindName("PuTTY")
$FileZilla = $Window.FindName("FileZilla")
$VSCode = $Window.FindName("VSCode")
#Local Tab
$HDV = $Window.FindName("HDV")
$TXViewer = $Window.FindName("TXViewer")
# Progress Bar
$ProgressBar = $Window.FindName("Progress")
# Buttons
$RunButton = $Window.FindName("RunButton")
$DomainButton = $Window.FindName("DomainButton")
$AdminButton = $Window.FindName("AdminButton")
$PowerSettings = $Window.FindName("PowerSettings")
$AppSetup = $Window.FindName("AppSetup")
#$ConsoleButton = $Window.FindName("ConsoleButton")
# Labels
$status = $Window.FindName("StatusLBL")
# Tabs
$LocalTab = $Window.FindName("LocalTab")

#Condition for local installations
if (Test-Path PowerSetup.json) {
    $LocalTab.Visibility="Visible"
}
# Click Actions
$PowerSettings.Add_Click({
    $PowerLangSetup.IsChecked = (-not $PowerLangSetup.IsChecked)
    $PowerNetSetup.IsChecked =(-not $PowerNetSetup.IsChecked)
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
    $Firefox.IsChecked =(-not $Firefox.IsChecked)
    $WinRAR.IsChecked = (-not $WinRAR.IsChecked)
    $VLC.IsChecked = (-not $VLC.IsChecked)
})
$DomainButton.Add_Click({ 
    $Serial = Get-WMIObject -Class "Win32_BIOS" | Select-Object -Expand SerialNumber
    $NewComputerName = (Read-Host -Prompt "Set Computer Name (with serial number: $Serial)") 
    $domain = (Read-Host -Prompt "        Enter domain name") 
    #$username = "USERNAME"
    #$password = "PASSWORD" | ConvertTo-SecureString -AsPlainText -Force
    #$Credential = New-Object System.Management.Automation.PSCredential($username,$password)
    Rename-Computer -NewName $NewComputerName 
    Add-Computer -DomainName $domain -Credential $domain\ -options JoinWithNewName -Force
})
$AdminButton.Add_Click({
    Countdown
    $Password = (Read-Host -Prompt "Set password for the Administrator account" -AsSecureString)
    $UserAccount = Get-LocalUser -Name "Administrator"
    $UserAccount | Set-LocalUser -Password $Password
    C:\WINDOWS\system32\net.exe user administrator /active:yes
})
#$ConsoleButton.Add_Click({ $Null = [Win32.Functions]::ShowWindow($hWnd, $SW_SHOW) })
$RunButton.Add_Click({
    Countdown
    DisableWpf
    Remove-WriteHost
    $RunButton.Visibility = "hidden"
    Countdown
    $ProgressBar.Visibility = "Visible"
    Countdown
    $status.Visibility = "Visible"
    Countdown
    If ($PowerLangSetup.IsChecked) { 
        Countdown
        $status.Content = "Setting Language, region, and keyboard languages... "
        PowerLangSetup
        $PowerLangSetup.IsChecked = $false
    }
    progCounter
    If ($PowerNetSetup.IsChecked) { 
        Countdown
        $status.Content = "Enabling firewall rule for Remote Desktop ... "
        PowerNetSetup
        $PowerNetSetup.IsChecked = $false
    }
    progCounter
    If ($PowerProxySetup.IsChecked) {
        Countdown
        $status.Content = "Disabling proxy... "
        PowerProxySetup
        $PowerProxySetup.IsChecked = $false
    }
    If ($PowerTimeSetup.IsChecked) {
        Countdown
        $status.Content = "Setting time and timezone... "
        PowerTimeSetup
        $PowerTimeSetup.IsChecked = $false
    }
    progCounter
    If ($PowerExplorerSetup.IsChecked ) {
        Countdown
        $status.Content = "Setting Windows Explorer and Taskbar settings... "
        PowerExplorerSetup
        $PowerExplorerSetup.IsChecked = $false
    }
    progCounter
    If ($PowerPlanSetup.IsChecked -and $env:UserName -ne "WDAGUtilityAccount" ) {
        Countdown
        $status.Content = "Setting active power plan to High Performance... "
        PowerPlanSetup
        $PowerPlanSetup.IsChecked = $false
    }
    progCounter
    If ($PowerDisplayTimer.IsChecked -and $env:UserName -ne "WDAGUtilityAccount") {
        Countdown
        $status.Content = "Turning off display timer... "
        PowerDisplayTimer
        $PowerDisplayTimer.IsChecked = $false
    }
    progCounter
    If ($PowerComputerTimer.IsChecked -and $env:UserName -ne "WDAGUtilityAccount") {
        Countdown
        $status.Content = "Turning off computer sleep timer... "
        PowerComputerTimer
        $PowerComputerTimer.IsChecked = $false
    }
    progCounter
    If ($PowerAppRemove.IsChecked) {
        Countdown
        $status.Content = "Removing Windows Store apps... "
        PowerAppRemove
        $PowerAppRemove.IsChecked = $false
    }
    progCounter
    If ($Option4.IsChecked) { }
    progCounter
    If ($Option5.IsChecked) { }
    progCounter
    If ($Option6.IsChecked) { }
    progCounter
    If ($Chrome.IsChecked -or $Firefox.IsChecked -or $Zoom.IsChecked -or $Teams.IsChecked -or $WinRAR.IsChecked -or $_7Zip.IsChecked -or $VLC.IsChecked -or $AppB4.IsChecked -or $AnyDesk.IsChecked -or $Team_Viewer.IsChecked -or $AppC3.IsChecked -or $AppC4.IsChecked -or $ACReader.IsChecked -or $PuTTY.IsChecked -or $FileZilla.IsChecked -or $VSCode.IsChecked) {
        Countdown
        $status.Content = " Preparing to install applications... "
        ChocoInstall
    }
    progCounter
    If ($Chrome.IsChecked) {
        Countdown
        $status.Content = " Installing Google Chrome... "
        Countdown
        choco install googlechrome -y
        $Chrome.IsChecked = $false
    }
    If ($Firefox.IsChecked) {
        Countdown
        $status.Content = " Installing Firefox... "
        Countdown
        choco install firefox -y
        $Firefox.IsChecked = $false
    }
    progCounter
    If ($Zoom.IsChecked) {
        Countdown
        $status.Content = " Installing Zoom... "
        Countdown
        choco install zoom -y
        $Zoom.IsChecked = $false
    }
    progCounter
    If ($Teams.IsChecked) {
        Countdown
        $status.Content = " Installing Microsoft Teams... "
        Countdown
        choco install microsoft-teams.install -y
        $Teams.IsChecked = $false

    }
    progCounter
    If ($WinRAR.IsChecked) {
        Countdown
        $status.Content = " Installing WinRAR... "
        Countdown
        choco install WinRAR -y
        $WinRAR.IsChecked = $false

    }
    progCounter
    If ($_7Zip.IsChecked) {
        Countdown
        $status.Content = " Installing 7Zip... "
        Countdown
        choco install 7Zip -y
        $_7Zip.IsChecked = $false

    }
    progCounter
    If ($VLC.IsChecked) {
        Countdown
        $status.Content = " Installing VLC... "
        Countdown
        choco install vlc -y
        $VLC.IsChecked = $false
    }
    progCounter
    If ($AppB4.IsChecked) {
    }
    progCounter
    If ($AnyDesk.IsChecked) {
        Countdown
        $status.Content = " Installing AnyDesk... "
        Countdown
        choco install anydesk.install -y
        $AnyDesk.IsChecked = $false

    }
    progCounter
    If ($Team_Viewer.IsChecked) {
        Countdown
        $status.Content = " Installing Team Viewer... "
        Countdown
        choco install teamviewer -y
        $Team_Viewer.IsChecked = $false
    }
    progCounter
    If ($AppC3.IsChecked) {
    }
    progCounter
    If ($AppC4.IsChecked) {
    }
    progCounter
    If ($ACReader.IsChecked) {
        Countdown
        $status.Content = " Installing Adobe Acrobat Reader DC... "
        Countdown
        choco install adobereader -y
        $ACReader.IsChecked = $false

    }
    progCounter
    If ($PuTTY.IsChecked) {
        Countdown
        $status.Content = " Installing PuTTY... "
        Countdown
        choco install putty -y
        $PuTTY.IsChecked = $false

    }
    progCounter
    If ($FileZilla.IsChecked) {
        Countdown
        $status.Content = " Installing Filezilla... "
        Countdown
        choco install filezilla -y
        $FileZilla.IsChecked = $false

    }
    progCounter
    If ($VSCode.IsChecked) {
        Countdown
        $status.Content = " Installing Visual Studio Code... "
        Countdown
        choco install vscode -y
        $VSCode.IsChecked = $false

    }
    progCounter
    If (Test-Path -Path "$env:ProgramData\Chocolatey") {
        Countdown
        $status.Content = " Cleaning Up... "
        Countdown
        ChocoRemove
    }
    progCounter
    If ($HDV.IsChecked -or $TXViewer.IsChecked){
        $location = Get-Content -Path PowerSetup.json | ConvertFrom-Json
    }
    If ($HDV.IsChecked) {
        Countdown
        $status.Content = " Installing HD Viewer... "
        Countdown
        Start-Process -FilePath "$env:systemroot\system32\msiexec.exe" -ArgumentList "/i `"$($location.HDV)`" /q"
        Start-Sleep -s 5
        $HDV.IsChecked = $false
    }
    progCounter
    If ($TXViewer.IsChecked) {
        Countdown
        $status.Content = " Installing TX Viewer... "
        Countdown
        Start-Process -FilePath "$env:systemroot\system32\msiexec.exe" -ArgumentList "/i `"$($location.TXViewer)`" /q"
        Start-Sleep -s 5
        $TXViewer.IsChecked = $false
    }
    progCounter
    $status.Content = " Setup Complete! "
    $ProgressPreference = 'Continue'
})
Function Countdown() {
    $Window.Dispatcher.Invoke([Action] {}, [Windows.Threading.DispatcherPriority]::ContextIdle);
}
$window.ShowDialog() | Out-Null
$Window.Add_ContentRendered({    
    Countdown   
})