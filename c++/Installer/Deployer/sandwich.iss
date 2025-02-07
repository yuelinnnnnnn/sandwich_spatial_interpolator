; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Sandwich"
#define MyAppVersion "1.7"
#define MyAppPublisher "Institute of Geographic Science and Natural Resources Research, CAS"
#define MyAppURL "http://www.sssampling.cn/"
#define MyAppExeName "Sandwich.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{86C19733-A224-4ECB-AEC6-F8E50F7C6263}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName}
DisableProgramGroupPage=yes
OutputDir=C:\Yue\Sandwich
OutputBaseFilename=Sandwich_setup_1.7
SetupIconFile=C:\Yue\Sandwich\sandwich.ico
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "C:\Yue\Sandwich\Sandwich.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Yue\Sandwich\d3dcompiler_47.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Yue\Sandwich\gdal201.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Yue\Sandwich\geos.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Yue\Sandwich\geos_c.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Yue\Sandwich\libEGL.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Yue\Sandwich\libGLESV2.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Yue\Sandwich\opengl32sw.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Yue\Sandwich\Qt5Core.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Yue\Sandwich\Qt5Gui.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Yue\Sandwich\Qt5Svg.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Yue\Sandwich\Qt5Widgets.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Yue\Sandwich\Sandwich\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "C:\Yue\Sandwich\platforms\*"; DestDir: "{app}\platforms"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{commonprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; 
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon; IconFilename:"{app}\sandwich.ico"

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

