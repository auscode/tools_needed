#define MyAppName "BLR Tools DataRecovery"
#define MyAppVersion "17.0.0"
#define MyCompany "BLR TOOLS"
#define MyAppId "BLR-DATA-RECOVERY-2025"
#define SourceDir "C:/Users/ram/OneDrive/Desktop/test-inst"
#define InstallerIcon "C:/Users/ram/OneDrive/Desktop/test-inst/logo/app-icon.ico"
#define WizardBanner "C:/Users/ram/OneDrive/Desktop/test-inst/logo/app-icon-4.bmp"
#define WizardSmall "C:/Users/ram/OneDrive/Desktop/test-inst/logo/blrtoolsbanner.bmp"
#define LicenseFile "C:/Users/ram/OneDrive/Desktop/test-inst/LICENSE.rtf"

[Setup]
; SignTool=safenet
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyCompany}
AppPublisherURL=https://www.blrtools.com
AppSupportURL=https://www.blrtools.com
AppUpdatesURL=https://www.blrtools.com/downloads
AppId={#MyAppId}
DefaultDirName={autopf}\{#MyCompany}\{#MyAppName}
DefaultGroupName={#MyAppName}
PrivilegesRequired=admin
; PrivilegesRequiredOverridesAllowed=none
AllowRootDirectory=yes
AllowNoIcons=yes
DisableDirPage=no
DisableProgramGroupPage=no
AppModifyPath="{uninstallexe}"

; 🔤 Auto-detect system language and skip dialog
LanguageDetectionMethod=locale
ShowLanguageDialog=no

; Uninstall details
Uninstallable=yes
UninstallDisplayName={#MyAppName}
UninstallDisplayIcon={app}\dataRecovery.exe
CreateUninstallRegKey=yes

; Compression
Compression=lzma
SolidCompression=yes
OutputBaseFilename=BLRTools_DataRecovery_Setup

; Version Info
VersionInfoVersion={#MyAppVersion}
VersionInfoCompany={#MyCompany}
VersionInfoDescription={#MyAppName}
VersionInfoProductName={#MyAppName}
VersionInfoProductVersion={#MyAppVersion}

; License
LicenseFile={#LicenseFile}

; Installer visuals
SetupIconFile={#InstallerIcon}
WizardImageFile={#WizardBanner}
WizardSmallImageFile={#WizardSmall}
WizardImageStretch=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"

[Files]
; Sign the main EXE before including it
#expr Exec("C:\Program Files (x86)\Windows Kits\10\bin\10.0.22621.0\x64\signtool.exe", \
  'sign /n "CERTFICATE_NAME" /fd SHA256 /tr http://timestamp.globalsign.com/tsa/r6advanced1 /td SHA256 /v "MAIN_EXE_LOCATION_PATH"')
Source: "{#SourceDir}\*"; DestDir: "{app}"; \
    Flags: ignoreversion recursesubdirs createallsubdirs; \
    Excludes: "application_output.log,*.pdb,*.cache,savedState\*"
Source: "{#SourceDir}\logo\app-icon.ico"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
; Main application icon
Name: "{group}\{#MyAppName}"; \
Filename: "{app}\dataRecovery.exe"; WorkingDir: "{app}"; IconFilename: "{app}\app-icon.ico"

; Windows Task Manager shortcut in your app's Start Menu folder
Name: "{group}\Task Manager"; \
Filename: "{sys}\Taskmgr.exe"; IconFilename: "{app}\app-icon.ico"; \
Comment: "Open Windows Task Manager"

; Windows Control Panel shortcut in your app's Start Menu folder
Name: "{group}\Control Panel"; \
Filename: "{sys}\control.exe"; IconFilename: "{app}\app-icon.ico"; \
Comment: "Open Windows Control Panel"

; Desktop icons
Name: "{autodesktop}\{#MyAppName}"; \
Filename: "{app}\dataRecovery.exe"; WorkingDir: "{app}"; IconFilename: "{app}\app-icon.ico"; \
Tasks: desktopicon

; Uninstall icon
Name: "{group}\Uninstall {#MyAppName}"; \
Filename: "{uninstallexe}"; IconFilename: "{app}\app-icon.ico"

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop icon"; GroupDescription: "Additional icons:"

[Run]
Filename: "{app}\dataRecovery.exe"; \
    Description: "Launch {#MyAppName}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
Type: filesandordirs; Name: "{app}"

; 🧾 Registry entries for uninstall (both 32-bit and 64-bit)
[Registry]
Root: HKLM; Subkey: "Software\Microsoft\Windows\CurrentVersion\Uninstall\{#MyAppId}_is1"; \
    ValueType: string; ValueName: "DisplayName"; ValueData: "{#MyAppName}"; Flags: uninsdeletekey
Root: HKLM; Subkey: "Software\Microsoft\Windows\CurrentVersion\Uninstall\{#MyAppId}_is1"; \
    ValueType: string; ValueName: "DisplayIcon"; ValueData: "{app}\dataRecovery.exe"
Root: HKLM; Subkey: "Software\Microsoft\Windows\CurrentVersion\Uninstall\{#MyAppId}_is1"; \
    ValueType: string; ValueName: "DisplayVersion"; ValueData: "{#MyAppVersion}"
Root: HKLM; Subkey: "Software\Microsoft\Windows\CurrentVersion\Uninstall\{#MyAppId}_is1"; \
    ValueType: string; ValueName: "Publisher"; ValueData: "{#MyCompany}"
Root: HKLM; Subkey: "Software\Microsoft\Windows\CurrentVersion\Uninstall\{#MyAppId}_is1"; \
    ValueType: string; ValueName: "URLInfoAbout"; ValueData: "https://www.blrtools.com"
Root: HKLM; Subkey: "Software\Microsoft\Windows\CurrentVersion\Uninstall\{#MyAppId}_is1"; \
    ValueType: string; ValueName: "InstallLocation"; ValueData: "{app}"
Root: HKLM; Subkey: "Software\Microsoft\Windows\CurrentVersion\Uninstall\{#MyAppId}_is1"; \
    ValueType: string; ValueName: "UninstallString"; ValueData: "{uninstallexe}"

[Code]
var
  ModifyPage: TInputOptionWizardPage;
  InstallPath: String;

procedure InitializeWizard;
begin
  if IsUninstaller then
    Exit;

  InstallPath :=
    ExpandConstant('{reg:HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\{#MyAppId}_is1,InstallLocation|}');
  if (InstallPath = '') then
    InstallPath :=
      ExpandConstant('{reg:HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\{#MyAppId}_is1,InstallLocation|}');

  if (InstallPath <> '') and DirExists(InstallPath) then
  begin
    ModifyPage := CreateInputOptionPage(
      wpWelcome,
      'Modify, Repair, or Remove Installation',
      'Choose the maintenance option you want to perform.',
      'Select whether you want to modify installed components, repair missing files, or remove the application.',
      True, False);
    ModifyPage.Add('Modify installation (change icons or settings)');
    ModifyPage.Add('Repair installation (replace missing or corrupted files)');
    ModifyPage.Add('Remove installation');
    ModifyPage.Values[0] := True;
  end;
end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin
  Result := False;
  if Assigned(ModifyPage) and (PageID = ModifyPage.ID) then
    Result := (InstallPath = '') or (not DirExists(InstallPath));
end;

function NextButtonClick(CurPageID: Integer): Boolean;
var
  ResultCode: Integer;
begin
  Result := True;

  if Assigned(ModifyPage) and (CurPageID = ModifyPage.ID) then
  begin
    case ModifyPage.SelectedValueIndex of
      0: begin
           MsgBox('Modify selected. Proceeding with normal installation options.', mbInformation, MB_OK);
         end;

      1: begin
           MsgBox('Repairing installation... Missing or corrupted files will be replaced.', mbInformation, MB_OK);
         end;

      2: begin
           if MsgBox('Are you sure you want to uninstall {#MyAppName}?', mbConfirmation, MB_YESNO) = IDYES then
           begin
             MsgBox('Starting uninstall...', mbInformation, MB_OK);
             
             // Run the actual uninstaller as the original (non-elevated) user
             ExecAsOriginalUser(
               ExpandConstant('{uninstallexe}'),
               '/VERYSILENT',
               '',
               SW_SHOW,
               ewNoWait,
               ResultCode
             );

             // Close this installer instance to allow uninstall to proceed
             WizardForm.Close;
             Result := False;
           end;
         end;
    end;
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if Assigned(ModifyPage) and (CurStep = ssInstall) then
  begin
    case ModifyPage.SelectedValueIndex of
      1: MsgBox('Repairing installation... Please wait while files are restored.', mbInformation, MB_OK);
      0: MsgBox('Modify selected. Proceeding with installation.', mbInformation, MB_OK);
    end;
  end;
end;

// Function to check if the process is running
// Checks whether a process with the given name is running
function IsAppRunning(const ExeName: String): Boolean;
var
  Locator, WMIService, ProcessList: Variant;
begin
  Result := False;
  try
    Locator := CreateOleObject('WbemScripting.SWbemLocator');
    WMIService := Locator.ConnectServer('.', 'root\CIMV2');
    // Only query processes matching the name (faster & more accurate)
    ProcessList := WMIService.ExecQuery(
      'SELECT Name FROM Win32_Process WHERE Name="' + ExeName + '"');
    if not VarIsNull(ProcessList) and (ProcessList.Count > 0) then
      Result := True;
  except
    // If WMI fails, assume not running
    Result := False;
  end;
end;

// Called before uninstaller runs
function InitializeUninstall(): Boolean;
begin
  Result := True;
  if IsAppRunning('dataRecovery.exe') then
  begin
    MsgBox('BLR Tools DataRecovery is currently running.'#13#13 +
           'Please close it before uninstalling.', mbCriticalError, MB_OK);
    Result := False;
  end;
end;
