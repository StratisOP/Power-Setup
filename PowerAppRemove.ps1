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
