[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]param()
function Import-Xaml {
    #Import Xaml for MainWindow
    [System.Reflection.Assembly]::LoadWithPartialName("PresentationFramework") | Out-Null
    [xml]$xaml = Get-Content -Path "$PSScriptRoot\MainWindowWPF.xaml"
    $manager = New-Object System.Xml.XmlNamespaceManager -ArgumentList $xaml.NameTable
    $manager.AddNamespace("x", "http://schemas.microsoft.com/winfx/2006/xaml");
    $xamlReader = (New-Object System.Xml.XmlNodeReader $xaml)
    [Windows.Markup.XamlReader]::Load($xamlReader)
}
function Import-Xaml1 {
    #Import Xaml for Admin/Domain
    [System.Reflection.Assembly]::LoadWithPartialName("PresentationFramework") | Out-Null
    [xml]$xaml1 = Get-Content -Path "$PSScriptRoot\AdminDomainWPF.xaml"
    $manager = New-Object System.Xml.XmlNamespaceManager -ArgumentList $xaml1.NameTable
    $manager.AddNamespace("x", "http://schemas.microsoft.com/winfx/2006/xaml");
    $xaml1reader = (New-Object System.Xml.XmlNodeReader $xaml1)
    [Windows.Markup.XamlReader]::Load($xaml1reader)
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
    $LocalAppA1.IsEnabled = $false
    $LocalAppA2.IsEnabled = $false
    $LocalAppB1.IsEnabled = $false
    $LocalAppC1.IsEnabled = $false
    $RunButton.IsEnabled = $false
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
# Tooltips
$PowerPlanSetup.ToolTip = "Setting High Performance as the active power plan"
$PowerDisplayTimer.ToolTip = "Turning off the display sleep timer"
$PowerComputerTimer.ToolTip = "Disabling putting computer to sleep"
$PowerExplorerSetup.ToolTip = "Setting Windows Explorer and Taskbar settings" 
$PowerAppRemove.ToolTip = "Removing the built-in Windows Store apps"
$PowerLangSetup.ToolTip = "Setting Language, region, and keyboard languages"
$PowerNetSetup.ToolTip = "Enabling firewall rule for Remote Desktop" 
$PowerProxySetup.ToolTip = "Disabling proxy"
$PowerTimeSetup.ToolTip = "Setting time and timezone"
# Application Setup Checkboxes
$Chrome = $Window.FindName("Chrome")
$Firefox = $Window.FindName("Firefox")
$Zoom = $Window.FindName("Zoom")
$Teams = $Window.FindName("Teams")

$WinRAR = $window.FindName("WinRAR")
$_7Zip = $Window.FindName("_7Zip")
$VLC = $Window.FindName("VLC")

$AnyDesk = $Window.FindName("AnyDesk")
$Team_Viewer = $Window.FindName("Team_Viewer")

$ACReader = $Window.FindName("ACReader")
$PuTTY = $Window.FindName("PuTTY")
$FileZilla = $Window.FindName("FileZilla")
$VSCode = $Window.FindName("VSCode")

$LocalAppA1 = $Window.FindName("LocalAppA1")
$LocalAppA2 = $Window.FindName("LocalAppA2")

$LocalAppB1 = $Window.FindName("LocalAppB1")

$LocalAppC1 = $Window.FindName("LocalAppC1")
# Progress Bar
$ProgressBar = $Window.FindName("Progress")
# Buttons
$RunButton = $Window.FindName("RunButton")
$PowerSettings = $Window.FindName("PowerSettings")
$AppSetup = $Window.FindName("AppSetup")
$AdminDomainSetup = $Window.FindName("AdminDomainSetup")
# Labels
$status = $Window.FindName("StatusLBL")
# Tabs
$ApplicationSetup = $Window.FindName("ApplicationSetup")
$LocalTab = $Window.FindName("LocalTab")

# Read config file if it exists
if (Test-Path PowerSetup.json) {
    $LocalTab.Visibility = "Visible"
    $ps = Get-Content -Path "$PSScriptRoot\PowerSetup.json" | ConvertFrom-Json
    $LocalAppA1.Content = $ps.app.LocalAppA1.Name
    $LocalAppA2.Content = $ps.app.LocalAppA2.Name
    $LocalAppB1.Content = $ps.app.LocalAppB1.Name
    $LocalAppC1.Content = $ps.app.LocalAppC1.Name
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
        $ApplicationSetup.SelectedIndex = 0
        $Chrome.IsChecked = (-not $Chrome.IsChecked)
        $Firefox.IsChecked = (-not $Firefox.IsChecked)
        $WinRAR.IsChecked = (-not $WinRAR.IsChecked)
        $VLC.IsChecked = (-not $VLC.IsChecked)
    })
    
$AdminDomainSetup.Add_Click({
        #Build the GUI
        $window1 = Import-Xaml1
        # XAML objects
        # Status Labels
        $DomainStatus = $window1.FindName("DomainStatus")
        $SerialStatus = $window1.FindName("SerialStatus")
        $PCNameStatus = $window1.FindName("PCNameStatus")
        $AdminStatus = $window1.FindName("AdminStatus")
        $HelpdeskStatus = $window1.FindName("HelpdeskStatus")
        # Setup buttons
        $SetAdmin = $window1.FindName("SetAdmin")
        $SetName = $window1.FindName("SetName")
        $SetHelpdesk = $window1.FindName("SetHelpdesk")
        $SetDomain = $window1.FindName("SetDomain")
    
        Import-Module Microsoft.Powershell.LocalAccounts 
    
        # Domain Status
        if ((Get-WmiObject win32_computersystem).partofdomain -eq $true) {
            $DomainStatus.Content = "$env:USERDNSDomain"
            $SetDomain.IsEnabled = $false
            $SetHelpdesk.IsEnabled = $true
        }
        elseif (!$ps.app.Domain) {
            $SetDomain.IsEnabled = $false
            $SetHelpdesk.IsEnabled = $false
        }
        else {
            $DomainStatus.Content = "WORKGROUP"
            $SetDomain.IsEnabled = $true
            $SetHelpdesk.IsEnabled = $false
        }
        # Serial Status
        $SerialStatus.Content = (Get-WmiObject win32_bios).serialnumber
        $SerialStatus.ToolTip = (Get-WmiObject win32_bios).serialnumber
        # Computer Name Status
        $PCNameStatus.Content = $env:computername
        $PCNameStatus.ToolTip = $env:computername
        # Find Computer Manufacturer
        $OEM = (Get-WmiObject win32_bios).manufacturer
        if ($OEM -eq "HP" -or $OEM -eq "Hewlett-Packard" ) {
            $vendor = "HP-"
        }
        elseif ($OEM -eq "Dell Inc.") {
            $vendor = "D-"
        }
        else {
            $vendor = ""
        }
        if ("$vendor$($SerialStatus.Content)" -eq $PCNameStatus.Content) {
            $SetName.IsEnabled = $false
        }
        # Admin Account Status
        $Admin = Get-LocalUser -Name Administrator
        if ($Admin.Enabled -eq $true) {
            $AdminStatus.Content = "True"
            $SetAdmin.IsEnabled = $false
        }
        else {
            $AdminStatus.Content = "False"
            $SetAdmin.IsEnabled = $true
        }
        # HelpdeskStatus Status

        $Admins = Get-LocalGroupMember -Name Administrators | Select-Object -ExpandProperty name
        if ($Admins -Contains "$($ps.config.Domain.Short)\$($ps.config.admin.account)") {
            $HelpdeskStatus.Content = "True"
            $SetHelpdesk.IsEnabled = $false
        } 
        else {
            $HelpdeskStatus.Content = "False"
        }
        $newName = "$vendor$($SerialStatus.Content)"
        # Enable Admin Account
        $SetAdmin.Add_Click({
                [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
                [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
                $objForm = New-Object Windows.Forms.Form -Property @{
                    StartPosition   = [Windows.Forms.FormStartPosition]::CenterScreen
                    FormBorderStyle = 'FixedDialog'
                    MaximizeBox     = $false
                    MinimizeBox     = $false
                    Size            = New-Object Drawing.Size 307, 142
                    Text            = "Set Password"
                    Topmost         = $True
                    KeyPreview      = $True
                }
                $objForm.Add_KeyDown({ if ($_.KeyCode -eq "Enter") 
                        { $x = $objTextBox.Text; $objForm.Close() } })
                $objForm.Add_KeyDown({ if ($_.KeyCode -eq "Escape") 
                        { $objForm.Close() } })
                $OKButton = New-Object Windows.Forms.Button -Property @{
                    Location     = New-Object Drawing.Point 75, 70
                    Size         = New-Object Drawing.Size 75, 23
                    Text         = 'OK'
                    Enabled      = $true
                    DialogResult = [Windows.Forms.DialogResult]::OK
                }
                $OKButton.Add_Click({ $x = $objTextBox.Text; $objForm.Close() })
                $objForm.Controls.Add($OKButton)

                $cancelButton = New-Object Windows.Forms.Button -Property @{
                    Location     = New-Object Drawing.Point 150, 70
                    Size         = New-Object Drawing.Size 75, 23
                    Text         = 'Cancel'
                    DialogResult = [Windows.Forms.DialogResult]::Cancel
                }
                $CancelButton.Add_Click({ $objForm.Close() })
                $objForm.Controls.Add($CancelButton)

                $objLabel = New-Object System.Windows.Forms.Label -Property @{
                    Text     = "Please enter a password for the administrator account: "
                    Location = New-Object Drawing.Point 9, 20 
                    Size     = New-Object Drawing.Size 280, 20
                }
                $objForm.Controls.Add($objLabel)
                $MaskedTextBox = New-Object System.Windows.Forms.MaskedTextBox -Property @{
                    PasswordChar = '*'
                    Location     = New-Object Drawing.Point 10, 40
                    Size         = New-Object Drawing.Size 270, 20
                }
                $objForm.Controls.Add($MaskedTextBox) 
                $objForm.Add_Shown({ $objForm.Activate() })
                $result = $objForm.ShowDialog()
                if ($result -eq [Windows.Forms.DialogResult]::OK) {
                    C:\WINDOWS\system32\net.exe user administrator $MaskedTextBox.Text
                    C:\WINDOWS\system32\net.exe user administrator /active:yes
                    $SetAdmin.IsEnabled = $false
                    $AdminStatus.Content = "True"
                }
            })
        # Set Computer name
        $SetName.Add_Click({
                Rename-Computer -NewName $newName -Force
                $SetName.IsEnabled = $false
            })
        # Add to domain
        $SetDomain.Add_Click({
                Add-Computer -DomainName $ps.config.Domain.full -Options JoinWithNewName -Force
                if ((Get-WmiObject win32_computersystem).partofdomain -eq $true) {
                    $SetDomain.IsEnabled = $false
                    $SetHelpdesk.IsEnabled = $true
                }
            })
        # Add Helpdesk to Administrators group
        $SetHelpdesk.Add_Click({
                Add-LocalGroupMember -Group Administrators -Member $env:USERDOMAIN\helpdesk
                $SetHelpdesk.IsEnabled = $false
            })
        $window1.Add_ContentRendered({
                Update-Gui
            })
        $window1.ShowDialog() | Out-Null
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
            $status.Content = "$($PowerLangSetup.ToolTip)..."
            Update-Gui
            PowerLangSetup
            #$PowerLangSetup.IsChecked = $false
        }
        progCounter
        If ($PowerNetSetup.IsChecked) { 
            Update-Gui
            $status.Content = "$($PowerNetSetup.ToolTip)..."
            Update-Gui
            PowerNetSetup
            #$PowerNetSetup.IsChecked = $false
        }
        progCounter
        If ($PowerProxySetup.IsChecked) {
            Update-Gui
            $status.Content = "$($PowerProxySetup.ToolTip)..."
            Update-Gui
            PowerProxySetup
            #$PowerProxySetup.IsChecked = $false
        }
        If ($PowerTimeSetup.IsChecked) {
            Update-Gui
            $status.Content = "$($PowerTimeSetup.ToolTip)..."
            Update-Gui
            PowerTimeSetup
            #$PowerTimeSetup.IsChecked = $false
        }
        progCounter
        If ($PowerExplorerSetup.IsChecked ) {
            Update-Gui
            $status.Content = "$($PowerExplorerSetup.ToolTip)..."
            Update-Gui
            PowerExplorerSetup
            #$PowerExplorerSetup.IsChecked = $false
        }
        progCounter
        If ($PowerPlanSetup.IsChecked -and $env:UserName -ne "WDAGUtilityAccount" ) {
            Update-Gui
            $status.Content = "$($PowerPlanSetup.ToolTip)..."
            Update-Gui
            PowerPlanSetup
            #$PowerPlanSetup.IsChecked = $false
        }
        progCounter
        If ($PowerDisplayTimer.IsChecked -and $env:UserName -ne "WDAGUtilityAccount") {
            Update-Gui
            $status.Content = "$($PowerDisplayTimer.ToolTip)..."
            Update-Gui
            PowerDisplayTimer
            #$PowerDisplayTimer.IsChecked = $false
        }
        progCounter
        If ($PowerComputerTimer.IsChecked -and $env:UserName -ne "WDAGUtilityAccount") {
            Update-Gui
            $status.Content = "$($PowerComputerTimer.ToolTip)..."
            Update-Gui
            PowerComputerTimer
            #$PowerComputerTimer.IsChecked = $false
        }
        progCounter
        If ($PowerAppRemove.IsChecked) {
            Update-Gui
            $status.Content = "$($PowerAppRemove.ToolTip)..."
            Update-Gui
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
        If ($LocalAppA1.IsChecked) {
            Update-Gui
            $status.Content = " Installing $($ps.app.LocalAppA1.Info)... "
            Update-Gui
            Start-Process -PassThru -FilePath "$env:systemroot\system32\msiexec.exe" -ArgumentList "/i `"$($ps.app.LocalAppA1.Path)`" /q" -Wait
            #$HDV.IsChecked = $false
        }
        progCounter
        If ($LocalAppA2.IsChecked) {
            Update-Gui
            $status.Content = " Installing $($ps.app.LocalAppA2.Info)... "
            Update-Gui
            Start-Process -PassThru -FilePath "$env:systemroot\system32\msiexec.exe" -ArgumentList "/i `"$($ps.app.LocalAppA2.Path)`" /q" -Wait
            #$TXViewer.IsChecked = $false
        }
        progCounter
        If ($LocalAppB1.IsChecked) {
            Update-Gui
            $status.Content = " Installing $($ps.app.LocalAppB1.Info)... "
            Update-Gui
            Start-Process -PassThru `"$($ps.app.LocalAppB1.Path)`" -NoNewWindow -Wait
        }
        progCounter
        If ($LocalAppC1.IsChecked) {
            Update-Gui
            $status.Content = " Installing $($ps.app.LocalAppC1.Info)... "
            Update-Gui
            Start-Process -PassThru -FilePath "$env:systemroot\system32\msiexec.exe" -ArgumentList "/i `"$($ps.app.LocalAppC1.Path)`" REBOOT=ReallySuppress /q" -Wait
            #$FortiClient.IsChecked = $false
        }
        progCounter
        $status.Content = " Setup Complete! "
        $ProgressPreference = 'Continue'
    })
Function Update-Gui() {
    $Window.Dispatcher.Invoke([Windows.Threading.DispatcherPriority]::Background, [action] {})
}
$Window.Add_ContentRendered({
        Update-Gui
    })
$window.ShowDialog() | Out-Null