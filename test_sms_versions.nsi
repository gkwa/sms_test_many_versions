!include LogicLib.nsh
!include FileFunc.nsh
!include MUI2.NSH
!include nsDialogs.nsh
!include nsis-streambox2\StreamboxNSISHelper.nsh

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

!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_INSTFILES # this macro is the macro that invokes the Sections
# !insertmacro MUI_PAGE_FINISH


!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
# !insertmacro MUI_UNPAGE_FINISH

!insertmacro KillRunningStreamboxApps ""
!insertmacro KillRunningStreamboxApps "Un."


;--------------------------------
; Languages

!insertmacro MUI_LANGUAGE "English"

;--------------------------------
; Functions

Function .onInit
	StrCpy $sysdrive $WINDIR 1

	SetAutoClose true
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


Function UN.onInit
	StrCpy $sysdrive $WINDIR 1
FunctionEnd

Section "Kill previous process" kill_previous_process
	SectionIn RO

	Call KillRunningStreamboxApps

# FIXME: KillRunningStreamboxApps is not enough aparantly.  Adding taskkill too

	nsExec::ExecToStack '"$SYSDIR\taskkill.exe" /F /IM cmd.exe'
	nsExec::ExecToStack '"$SYSDIR\taskkill.exe" /F /IM sms1.exe'
	nsExec::ExecToStack '"$SYSDIR\taskkill.exe" /F /IM sms.exe'

	SetOutPath $sysdrive:\Streambox\SMS
	Delete $sysdrive:\Streambox\SMS\sms1.exe
	Delete $sysdrive:\Streambox\SMS\sms.exe

	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User company Streambox
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User compname test
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User email taylor.monacelli@streambox.com
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User name2 Monacelli
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User name1 Taylor


SectionEnd

##############################
# sms versions
##############################

Section /o v1.74 section_v1.74
	File sms_versions\Volumes\Production\MediaStation\1.74\sms1.exe
	File sms_versions\Volumes\Production\MediaStation\1.74\sb.mov
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 1553042
SectionEnd

Section /o v1.73 section_v1.73
	File sms_versions\Volumes\Production\MediaStation\1.73\sms1.exe
	File sms_versions\Volumes\Production\MediaStation\1.73\sb.mov
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 1553042
SectionEnd

Section /o v1.72 section_v1.72
	File sms_versions\Volumes\Production\MediaStation\1.72\sms1.exe
	File sms_versions\Volumes\Production\MediaStation\1.72\sb.mov
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 1553042
SectionEnd

Section /o v1.71 section_v1.71
	File sms_versions\Volumes\Production\MediaStation\1.71\sms1.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 1553042
SectionEnd

Section /o v1.70 section_v1.70
	File sms_versions\Volumes\Production\MediaStation\1.70\sms1.exe
	File sms_versions\Volumes\Production\MediaStation\1.70\sb.mov
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 1553042
SectionEnd

Section /o v1.69 section_v1.69
	File sms_versions\Volumes\Production\MediaStation\1.69\sms1.exe
	File sms_versions\Volumes\Production\MediaStation\1.69\sb.bmp
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 1553042
SectionEnd

Section /o v1.68 section_v1.68
	File sms_versions\Volumes\Production\MediaStation\1.68\sms1.exe
	File sms_versions\Volumes\Production\MediaStation\1.68\sb.bmp
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 1553042
SectionEnd

Section /o v1.67 section_v1.67
	File sms_versions\Volumes\Production\MediaStation\1.67\sms1.exe
	File sms_versions\Volumes\Production\MediaStation\1.67\sb.bmp
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 1553042
SectionEnd

Section /o v1.66 section_v1.66
	File sms_versions\Volumes\Production\MediaStation\1.66\sms1.exe
	File sms_versions\Volumes\Production\MediaStation\1.66\sb.bmp
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 1553042
SectionEnd

Section /o v1.65 section_v1.65
	File sms_versions\Volumes\Production\MediaStation\1.65\sms1.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 1553042
SectionEnd

Section /o v1.64 section_v1.64
	File sms_versions\Volumes\Production\MediaStation\1.64\sms1.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 3168985
SectionEnd

Section /o v1.63 section_v1.63
	File sms_versions\Volumes\Production\MediaStation\1.63\sms1.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 3168985
SectionEnd

Section /o v1.62 section_v1.62
	File sms_versions\Volumes\Production\MediaStation\1.62\sms1.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 3168985
SectionEnd

Section /o v1.61 section_v1.61
	File sms_versions\Volumes\Production\MediaStation\1.61\sms1.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 3168985
SectionEnd

Section /o v1.60 section_v1.60
	File sms_versions\Volumes\Production\MediaStation\1.60\sms1.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 3168985
SectionEnd

Section /o v1.59 section_v1.59
	File sms_versions\Volumes\Production\MediaStation\1.59\sms1.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 3168985
SectionEnd

Section /o v1.58 section_v1.58
	File sms_versions\Volumes\Production\MediaStation\1.58\sms.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 3168985
SectionEnd

Section /o v1.57 section_v1.57
	File sms_versions\Volumes\Production\MediaStation\1.57\sms.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 3168985
SectionEnd

Section /o v1.56 section_v1.56
	File sms_versions\Volumes\Production\MediaStation\1.56\sms.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 3168985
SectionEnd

Section /o v1.55 section_v1.55
	File sms_versions\Volumes\Production\MediaStation\1.55\sms.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 3168985
SectionEnd

Section /o v1.53 section_v1.53
	File sms_versions\Volumes\Production\MediaStation\1.53\sms.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 3168985
SectionEnd

Section /o "v1.53 no preview" section_v1.53_no_preview
	File sms_versions\Volumes\Production\MediaStation\1.53\no-preview\sms.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 3168985
SectionEnd

Section /o v1.52 section_v1.52
	File sms_versions\Volumes\Production\MediaStation\1.52\sms.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 3168985
SectionEnd

Section /o v1.51b section_v1.51b
	File sms_versions\Volumes\Production\MediaStation\1.51b\sms.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 3168985
SectionEnd

Section /o v1.51 section_v1.51
	File sms_versions\Volumes\Production\MediaStation\1.51\sms.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 3168985
SectionEnd

Section /o v1.5 section_v1.5

	# uses AS1
	# 9880657, 1766338, 6196732, 9714956, 3700729, 3347280, 6583394, 3391147, 4353544, 7303549, 2942638, 6364144, 2406704, 2606004, 8586687, 3613751, 4553327, 6726733, 2959307, 5575148, 4075300, 1075768, 6744441, 8588652, 5971028, 6099034, 4951300, 8507204, 6617909, 4954481, 2908537, 6121890, 7367208, 6226456, 5620676, 2223043, 7163054, 4601074, 7336588, 2234754, 2696803, 1798787, 1598176, 8516757, 4323662, 9416832, 4136059, 3312722, 1267861, 8902487, 2058785, 4150639, 8675878, 5678859, 7852529, 2329989, 3069905, 3230589, 3168985, 7965506, 6524799, 7742305, 5529002, 7955498, 1220877, 1145814, 5475734, 5535702, 5505967, 9239614, 3846514, 5955034, 8764111, 7614037, 3953191, 6242234, 7307196, 9617819, 6392971, 5881533, 3673130, 3700240, 7909445, 7410744, 9267444, 5724424, 1327187, 2786693, 7709191, 3580074, 4808072, 7053924, 6193433, 5170562, 2232466, 1256068, 8571452, 5344338, 3082329, 6476309 

	File sms_versions\Volumes\Production\MediaStation\1.5\sms.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 9880657
SectionEnd

Section /o v1.4.8_ringbuffer section_v1.4.8_ringbuffer
	File sms_versions\Volumes\Production\MediaStation\1.4.8_ringbuffer\Streambox\sms.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 3168985
SectionEnd

Section /o v1.4.8 section_v1.4.8
	File sms_versions\Volumes\Production\MediaStation\1.4.8\Streambox\sms.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 3168985
SectionEnd

Section /o v1.4.7 section_v1.4.7
	File sms_versions\Volumes\Production\MediaStation\1.4.7\Streambox\sms.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 3168985
SectionEnd

Section /o v1.4.6 section_v1.4.6
	File sms_versions\Volumes\Production\MediaStation\1.4.6\Streambox\sms.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 3168985
SectionEnd

Section /o v1.4.5 section_v1.4.5
	File sms_versions\Volumes\Production\MediaStation\1.4.5\Streambox\sms.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 3168985
SectionEnd

Section /o v1.4.4 section_v1.4.4
	File sms_versions\Volumes\Production\MediaStation\1.4.4\sms.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 3168985
SectionEnd

Section /o v1.4.3 section_v1.4.3
	File sms_versions\Volumes\Production\MediaStation\1.4.3\sms.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 3168985
SectionEnd

Section /o v1.4.2 section_v1.4.2
	File sms_versions\Volumes\Production\MediaStation\1.4.2\sms.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 3168985
SectionEnd

Section /o v1.4.1c section_v1.4.1c
	File sms_versions\Volumes\Production\MediaStation\1.4.1c\sms.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 3168985
SectionEnd

Section /o v1.4.1b section_v1.4.1b
	File sms_versions\Volumes\Production\MediaStation\1.4.1b\sms.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 3168985
SectionEnd

Section /o v1.4.1a section_v1.4.1a
	File sms_versions\Volumes\Production\MediaStation\1.4.1a\sms.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 3168985
SectionEnd

Section /o v1.4.1 section_v1.4.1
	File sms_versions\Volumes\Production\MediaStation\1.4.1\sms.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 3168985
SectionEnd

Section /o v1.4.0 section_v1.4.0
	File sms_versions\Volumes\Production\MediaStation\1.4.0\sms.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 3168985
SectionEnd

Section /o v1.3.7-04-27-2010 section_v1.3.7-04-27-2010
	File sms_versions\Volumes\Production\MediaStation\1.3.7-04-27-2010\sms.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 3168985
SectionEnd

Section /o v1.3.7 section_v1.3.7
	File sms_versions\Volumes\Production\MediaStation\1.3.7\sms.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 3168985
SectionEnd

Section /o v1.3.6 section_v1.3.6
	File sms_versions\Volumes\Production\MediaStation\1.3.6\sms.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 3168985
SectionEnd

Section /o v1.3.5 section_v1.3.5
	File sms_versions\Volumes\Production\MediaStation\1.3.5\sms.exe
	WriteINIStr $sysdrive:\Streambox\SMS\license_sms.lic User Code 3168985
SectionEnd

Section "Rename logs" section_rename_logs

	SetOutPath $sysdrive:\Streambox\SMS
	${GetTime} "" "L" $0 $1 $2 $3 $4 $5 $6
	; $0="01"      day
	; $1="04"      month
	; $2="2005"    year
	; $3="Friday"  day of week name
	; $4="16"      hour
	; $5="05"      minute
	; $6="50"      seconds
	Rename $sysdrive:\Streambox\SMS\sms.log $sysdrive:\Streambox\SMS\sms_$2$1$0$4$5$6.log
	Rename $sysdrive:\Streambox\SMS\sms1.log $sysdrive:\Streambox\SMS\sms1_$2$1$0$4$5$6.log

SectionEnd

##############################
# sms versions
##############################

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
