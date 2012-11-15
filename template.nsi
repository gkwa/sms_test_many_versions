!include LogicLib.nsh
!include FileFunc.nsh
!include MUI2.NSH
!include nsDialogs.nsh

Name "${name}"
OutFile "${outfile}"

XPStyle on
ShowInstDetails show
ShowUninstDetails show
RequestExecutionLevel admin
Caption "Streambox $(^Name) Installer"

# use this as installdir
InstallDir '$PROGRAMFILES\Streambox\${name}'
#...butif this reg key exists, use this installdir instead of the above line
InstallDirRegKey HKLM 'Software\Streambox\${name}' InstallDir

!define LANG_ENGLISH 1033-English

VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "My Fun Product"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "Creates fun things"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "@Streambox"
VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "Streambox"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "${version}"
VIProductVersion "${version}"

;--------------------------------
; docs
# http://nsis.sourceforge.net/Docs
# http://nsis.sourceforge.net/Macro_vs_Function
# http://nsis.sourceforge.net/Adding_custom_installer_pages
# http://nsis.sourceforge.net/ConfigWrite
# loops
# http://nsis.sourceforge.net/Docs/Chapter2.html#\2.3.6

;--------------------------------
Var Dialog
Var sysdrive
var debug

;--------------------------------
;Interface Configuration

!define MUI_WELCOMEPAGE_TITLE "Welcome to the Streambox setup wizard."
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_RIGHT
!define MUI_HEADERIMAGE_BITMAP nsis-streambox2\Graphics\sblogo.bmp
!define MUI_WELCOMEFINISHPAGE_BITMAP nsis-streambox2\Graphics\sbside.bmp
!define MUI_UNWELCOMEFINISHPAGE_BITMAP nsis-streambox2\Graphics\sbside.bmp
!define MUI_ABORTWARNING
!define MUI_ICON nsis-streambox2\Icons\Streambox_128.ico

UninstallText "This will uninstall ${name}"

;--------------------------------
;Pages

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE nsis-streambox2\Docs\License.txt
!insertmacro NSD_FUNCTION_INIFILE
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
Page custom nsDialogsPage nsDialogsPageLeave
!insertmacro MUI_PAGE_INSTFILES # this macro is the macro that invokes the Sections
# !insertmacro MUI_PAGE_FINISH

!define MUI_WELCOMEPAGE_TITLE "Welcome to Streambox uninstall wizard."
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
# !insertmacro MUI_UNPAGE_FINISH

;--------------------------------
; Languages

!insertmacro MUI_LANGUAGE "English"

;--------------------------------
; Functions

Function .onInit
	StrCpy $sysdrive $WINDIR 1

	##############################
	# did we call with "/debug"
	StrCpy $debug 0
	${GetParameters} $0
	ClearErrors
	${GetOptions} $0 '/debug' $1
	${IfNot} ${Errors}
		StrCpy $debug 1
		SetAutoClose false #leave installer window open when /debug
	${EndIf}
	ClearErrors

FunctionEnd

Function .onInstSuccess
FunctionEnd

Function nsDialogsPageLeave

FunctionEnd

Function UN.onInit
	StrCpy $sysdrive $WINDIR 1
FunctionEnd

Section section1 section_section1
	CreateDirectory	"$INSTDIR"
	DetailPrint "hello world"


	SetOutPath '$TEMP\${name}'

	CreateDirectory	"$INSTDIR"

	StrCpy $0 '$PROGRAMFILES\Streambox\${name}\Uninstall.exe'
	WriteUninstaller "$0"
	WriteRegStr HKLM 'Software\Microsoft\Windows\CurrentVersion\Uninstall\${name}' UninstallString "$0"
	WriteRegStr HKLM 'Software\Microsoft\Windows\CurrentVersion\Uninstall\${name}' DisplayName '${name} v${version}'
	WriteRegStr HKLM 'Software\Microsoft\Windows\CurrentVersion\Uninstall\${name}' DisplayIcon "$0"
	WriteRegDWORD HKLM 'Software\Microsoft\Windows\CurrentVersion\Uninstall\${name}' NoModify 1

	${If} 0 == $debug
		rmdir '$TEMP\${name}'
	${EndIf}

SectionEnd
LangString DESC_section1 ${LANG_ENGLISH} \
"Description of section 1."

Section section2 section_section2

SectionEnd
LangString DESC_section2 ${LANG_ENGLISH} \
"Description of section 2."

Section uninstall section_uninstall

	rmdir /r "$PROGRAMFILES\Streambox\${name}"
	rmdir "$PROGRAMFILES\Streambox"

	DeleteRegKey HKLM 'Software\Streambox\${name}'
	DeleteRegKey /ifempty HKLM 'Software\Streambox'

	# Remove from microsoft Add/remove Programs applet
	DeleteRegKey HKLM 'Software\Microsoft\Windows\CurrentVersion\Uninstall\${name}'
SectionEnd

UninstallIcon nsis-streambox2\Icons\Streambox_128.ico

;--------------------------------
; this must remain after the Section definitions

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
	!insertmacro MUI_DESCRIPTION_TEXT ${section_section1} $(DESC_section1)
	!insertmacro MUI_DESCRIPTION_TEXT ${section_section2} $(DESC_section2)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

# Emacs vars
# Local Variables: ***
# comment-column:0 ***
# tab-width: 2 ***
# comment-start:"# " ***
# End: ***
