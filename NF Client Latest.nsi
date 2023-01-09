; Script generated by the HM NIS Edit Script Wizard.

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "NF Client (Fabric) 1.19.3"
!define PRODUCT_VERSION "1.1.0"
!define PRODUCT_PUBLISHER "NF Client"
!define PRODUCT_WEB_SITE "https://www.nfclient.kro.kr"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

; MUI 1.67 compatible ------
!include "MUI.nsh"
!ifndef IPersistFile
!define IPersistFile {0000010b-0000-0000-c000-000000000046}
!endif
!ifndef CLSID_ShellLink
!define CLSID_ShellLink {00021401-0000-0000-C000-000000000046}
!define IID_IShellLinkA {000214EE-0000-0000-C000-000000000046}
!define IID_IShellLinkW {000214F9-0000-0000-C000-000000000046}
!define IShellLinkDataList {45e2b4ae-b1c3-11d0-b92f-00a0c90312e1}
	!ifdef NSIS_UNICODE
	!define IID_IShellLink ${IID_IShellLinkW}
	!else
	!define IID_IShellLink ${IID_IShellLinkA}
	!endif
!endif

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "nfclient.ico"
!define MUI_UNICON "nfclient.ico"
BrandingText "NF Client"

!define MUI_WELCOMEFINISHPAGE_BITMAP "나죠안 스킨.bmp"
; Welcome page
!insertmacro MUI_PAGE_WELCOME
!define MUI_PAGE_HEADER_TEXT "주의"
!define MUI_PAGE_HEADER_SUBTEXT "아래 내용은 꼭 읽어주세요."
; License page
!insertmacro MUI_PAGE_LICENSE "통합.txt"
LicenseForceSelection checkbox
; Directory page

; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!insertmacro MUI_PAGE_FINISH

; Language files
!insertmacro MUI_LANGUAGE "Korean"

; MUI end ------

Name "${PRODUCT_NAME} v${PRODUCT_VERSION}"
OutFile "NF_Client_1.19.3.exe"
RequestExecutionLevel admin
InstallDir "$APPDATA\.nfclient-latest"
ShowInstDetails hide

Function ShellLinkSetRunAs
System::Store S
pop $9
System::Call "ole32::CoCreateInstance(g'${CLSID_ShellLink}',i0,i1,g'${IID_IShellLink}',*i.r1)i.r0"
${If} $0 = 0
	System::Call "$1->0(g'${IPersistFile}',*i.r2)i.r0" ;QI
	${If} $0 = 0
		System::Call "$2->5(w '$9',i 0)i.r0" ;Load
		${If} $0 = 0
			System::Call "$1->0(g'${IShellLinkDataList}',*i.r3)i.r0" ;QI
			${If} $0 = 0
				System::Call "$3->6(*i.r4)i.r0" ;GetFlags
				${If} $0 = 0
					System::Call "$3->7(i $4|0x2000)i.r0" ;SetFlags ;SLDF_RUNAS_USER
					${If} $0 = 0
						System::Call "$2->6(w '$9',i1)i.r0" ;Save
					${EndIf}
				${EndIf}
				System::Call "$3->2()" ;Release
			${EndIf}
		System::Call "$2->2()" ;Release
		${EndIf}
	${EndIf}
	System::Call "$1->2()" ;Release
${EndIf}
push $0
System::Store L
FunctionEnd

Section "MainSection" SEC01
  SetOverwrite on
  AddSize 1000000
  Messagebox MB_OKCANCEL "경고: ${PRODUCT_NAME} 폴더(.nfclient-latest)에 수동으로 설치한 $\n모드는 삭제되며, 실행중인 마인크래프트는 강제로 종료됩니다.$\n$\n설치를 취소하시려면 취소를 누르세요" IDCANCEL END
  SetOutPath "$INSTDIR"
  File "start.bat"
  ExecWait '"start.bat"'
  delete "start.bat"
  Sleep 5000
  ;fabric check version
  iffileexists "$APPDATA\.nfclient-latest\versions\1.19.3\1.19.3.jar" O X
X:
  RMDir /r "$APPDATA\.nfclient-latest\assets"
  RMDir /r "$APPDATA\.nfclient-latest\libraries"
  RMDir /r "$APPDATA\.nfclient-latest\versions"
  goto fabric
O:
  Messagebox MB_YESNO "${PRODUCT_NAME}을 설치한 이력이 있습니다. Fabric 설치를 건너뛰겠습니까?" IDYES skip IDNO fabric
fabric:
  delete "launcher_profiles.json"
  delete "launcher_ui_state.json"
  Nsisdl::download "https://blog.kakaocdn.net/dn/k74Yy/btqFIOze0RG/ckQOY9gpF5J4iMfcKJotH1/7z.exe?attach=1&knm=tfile.exe" "7z.exe"
  inetc::get /NOCANCEL /TRANSLATE "Fabric 설치 중 (1/1)" "연결 중..." 초 분 시간 "" "" "%d %s %s 남음" /WEAKSECURITY "https://www.dropbox.com/s/25060g9vedz0i7q/.minecraft.7z?dl=1" "fabric.7z"
  nsexec::exec '$INSTDIR\7z.exe x "$instdir\fabric.7z" "-aoa"'
  delete "7z.exe"
  delete "fabric.7z"
  goto skip
skip:
  ;mod
  RMDir /r "$INSTDIR\mods"
  SetOutPath "$INSTDIR\mods"
  Nsisdl::download "https://blog.kakaocdn.net/dn/k74Yy/btqFIOze0RG/ckQOY9gpF5J4iMfcKJotH1/7z.exe?attach=1&knm=tfile.exe" "7z.exe"
  Nsisdl::download /TRANSLATE2 "모드 설치중 (1/1)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "http://132.226.170.151/file/nflatest/mods.7z" "mods.7z"
  nsexec::exec '$INSTDIR\mods\7z.exe x "$instdir\mods\mods.7z" "-aoa"'
  delete "7z.exe"
  delete "mods.7z"
  ;options
  SetOutPath "$INSTDIR"
  Nsisdl::download "https://blog.kakaocdn.net/dn/k74Yy/btqFIOze0RG/ckQOY9gpF5J4iMfcKJotH1/7z.exe?attach=1&knm=tfile.exe" "7z.exe"
  Nsisdl::download "http://132.226.170.151/file/nflatest/options.7z" "options.7z"
  nsexec::exec '$INSTDIR\7z.exe x "$instdir\options.7z" "-aos"'
  delete "7z.exe"
  delete "options.7z"
  ;resourcepack
  SetOverwrite on
  SetOutPath "$INSTDIR\resourcepacks"
  RMDir /r "$INSTDIR\resourcepacks\§c나죠안의 커스텀 팩 1.19.3 SE"
  Nsisdl::download "https://blog.kakaocdn.net/dn/k74Yy/btqFIOze0RG/ckQOY9gpF5J4iMfcKJotH1/7z.exe?attach=1&knm=tfile.exe" "7z.exe"
  Nsisdl::download /TRANSLATE2 "커스텀 팩 설치중 (1/1)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "http://132.226.170.151/file/nflatest/resourcepack.7z" "resourcepack.7z"
  nsexec::exec '$INSTDIR\resourcepacks\7z.exe x "$instdir\resourcepacks\resourcepack.7z" "-aoa"'
  delete "resourcepack.7z"
  delete "7z.exe"
  
  ;install launcher
  SetOutPath "$PROGRAMFILES\Minecraft Launcher\"
  File "nfclient.ico"
  SetOverwrite off
  iffileexists "$PROGRAMFILES\Minecraft Launcher\MinecraftLauncher.exe" launcher nonlauncher
nonlauncher:
  Nsisdl::download /TRANSLATE2 "마인크래프트 런처 설치 중 (1/1)" "연결중입니다.." "(1 초 남았습니다...)" "(1 분 남았습니다...)" "(1 시간 남았습니다)" "(%u 초 남았습니다....)" "(%u 분 남았습니다....)" "(%u 시간 남았습니다)" "다운로드 중 " "https://blog.kakaocdn.net/dn/buRRdi/btq09jZtZc4/sRT9b5pjQ7Is2RN6H4SOMK/MinecraftLauncher.exe?attach=1&knm=tfile.exe" "MinecraftLauncher.exe"
launcher:
  SetOverwrite on
  CreateShortCut "$DESKTOP\NF Client (Fabric).lnk" "$PROGRAMFILES\Minecraft Launcher\MinecraftLauncher.exe" '--workDir "$INSTDIR"' "$PROGRAMFILES\Minecraft Launcher\nfclient.ico"
  CreateShortCut "$STARTMENU\Programs\NF Client (Fabric).lnk" "$PROGRAMFILES\Minecraft Launcher\MinecraftLauncher.exe" '--workDir "$INSTDIR"' "$PROGRAMFILES\Minecraft Launcher\nfclient.ico"
  push "$DESKTOP\NF Client (Fabric).lnk"
  call ShellLinkSetRunAs
  pop $0
  push "$STARTMENU\Programs\NF Client (Fabric).lnk"
  call ShellLinkSetRunAs
  pop $0
  Messagebox MB_OK "설치가 완료되었습니다! 바탕화면에 있는 NF Client (Fabric)를 실행해주세요!$\n제거하실 때는 제어판 -> 프로그램 제거 -> ${PRODUCT_NAME} v${PRODUCT_VERSION}"
  goto END

END:

SectionEnd

;uninstall
Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$PROGRAMFILES\Minecraft Launcher\nfclient.ico"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name)은(는) 완전히 제거되었습니다."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "$(^Name)을(를) 제거하시겠습니까?" IDYES +2
  Abort
FunctionEnd

Section "un.언인스톨"
  delete "$DESKTOP\NF Client (Fabric).lnk"
  delete "$STARTMENU\Programs\NF Client (Fabric).lnk"
  RMDir /r "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  SetAutoClose true
SectionEnd