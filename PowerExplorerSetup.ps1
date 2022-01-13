$WinExpPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer"
$WinExpPathAdv = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$PolWinExp = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer"

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
Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent DisableSoftLanding 1
#Hide search box on taskbar
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search SearchboxTaskbarMode 0
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