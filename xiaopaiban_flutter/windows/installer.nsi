; NSIS Script for 小排版 Flutter Desktop Application
; This script creates a Windows installer for the Flutter desktop app

!include "MUI2.nsh"
!include "FileFunc.nsh"

; Application information
!define APP_NAME "小排版"
!define APP_PUBLISHER "小排版开发团队"
!define APP_URL "https://github.com/qhzhq/xiaopaiban"
!define APP_VERSION "2.0.1"
!define APP_EXE "小排版.exe"
!define APP_ICON "app_icon.ico"
!define APP_UNINSTALLER "Uninstall.exe"

; Installer attributes
Name "${APP_NAME} ${APP_VERSION}"
OutFile "小排版_${APP_VERSION}_Windows_x64.exe"
InstallDir "$PROGRAMFILES64\${APP_NAME}"
InstallDirRegKey HKLM "Software\${APP_NAME}" "InstallDir"
RequestExecutionLevel admin

; Modern UI Configuration
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; Installer pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "LICENSE"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

; Language
!insertmacro MUI_LANGUAGE "SimpChinese"

; Version information
VIProductVersion "${APP_VERSION}.0"
VIAddVersionKey "ProductName" "${APP_NAME}"
VIAddVersionKey "CompanyName" "${APP_PUBLISHER}"
VIAddVersionKey "FileVersion" "${APP_VERSION}"
VIAddVersionKey "FileDescription" "${APP_NAME} 安装程序"
VIAddVersionKey "LegalCopyright" "© ${APP_PUBLISHER}"

; Installer sections
Section "安装 ${APP_NAME}" SecMain
  SetOutPath "$INSTDIR"
  
  ; Add files
  File /r "build\windows\x64\runner\Release\*.*"
  
  ; Create uninstaller
  WriteUninstaller "$INSTDIR\${APP_UNINSTALLER}"
  
  ; Create start menu items
  CreateDirectory "$SMPROGRAMS\${APP_NAME}"
  CreateShortCut "$SMPROGRAMS\${APP_NAME}\${APP_NAME}.lnk" "$INSTDIR\${APP_EXE}"
  CreateShortCut "$SMPROGRAMS\${APP_NAME}\卸载 ${APP_NAME}.lnk" "$INSTDIR\${APP_UNINSTALLER}"
  
  ; Create desktop shortcut
  CreateShortCut "$DESKTOP\${APP_NAME}.lnk" "$INSTDIR\${APP_EXE}"
  
  ; Write registry keys
  WriteRegStr HKLM "Software\${APP_NAME}" "InstallDir" "$INSTDIR"
  WriteRegStr HKLM "Software\${APP_NAME}" "Version" "${APP_VERSION}"
  
  ; Write uninstall information
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayName" "${APP_NAME}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "UninstallString" "$\"$INSTDIR\${APP_UNINSTALLER}$\""
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "QuietUninstallString" "$\"$INSTDIR\${APP_UNINSTALLER}$\" /S"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "InstallLocation" "$INSTDIR"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayVersion" "${APP_VERSION}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "Publisher" "${APP_PUBLISHER}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "URLInfoAbout" "${APP_URL}"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "NoRepair" 1
  
  ; Get installed size
  ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
  IntFmt $0 "0x%08X" $0
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "EstimatedSize" "$0"
SectionEnd

; Uninstaller section
Section "Uninstall"
  ; Remove files
  RMDir /r "$INSTDIR"
  
  ; Remove start menu items
  RMDir /r "$SMPROGRAMS\${APP_NAME}"
  
  ; Remove desktop shortcut
  Delete "$DESKTOP\${APP_NAME}.lnk"
  
  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"
  DeleteRegKey HKLM "Software\${APP_NAME}"
SectionEnd