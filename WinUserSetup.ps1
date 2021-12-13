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
$WinExpPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer"
$WinExpPathAdv = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$PolWinExp = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer"

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

#Set Language, region, and keyboard languages
Set-Culture en-US
Set-WinUILanguageOverride -Language en-US
Set-WinUserLanguageList en-US, el-GR -Force
Set-WinHomeLocation -GeoId 98
Set-WinSystemLocale -SystemLocale el-GR #On next boot

#Disable Automatically Detect proxy settings
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" AutoDetect 0

#Set time automatically
Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters Type NTP
#Set timezone automatically 
Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate Start 3

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
#Disable Edge desktop shortcut on new user accounts:
Set-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer DisableEdgeDesktopShortcutCreation 1
#Disable "tips, tricks and suggestions"
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