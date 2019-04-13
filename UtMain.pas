unit UtMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TlHelp32;

type
  TfrmMain = class(TForm)
    btnCheck: TButton;
    procedure btnCheckClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.btnCheckClick(Sender: TObject);
var
 Is_Sandboxed:Boolean;
 I:Integer;
 Handle: THandle;
 ModuleEntry: TModuleEntry32;
 Modules:TStringList;
begin
  Modules := TStringList.Create;
  Handle := CreateToolHelp32SnapShot(TH32CS_SNAPMODULE, 0);
  Win32Check(Handle <> INVALID_HANDLE_VALUE);
  try
    ModuleEntry.dwSize := Sizeof(ModuleEntry);
    Win32Check(Module32First(Handle, ModuleEntry));
    repeat
      Modules.Add(ModuleEntry.szModule);
    until not Module32Next(Handle, ModuleEntry);
  finally
    CloseHandle(Handle);
  end;



  Is_Sandboxed := False;

  for I := 0 to Modules.Count - 1 do
  begin
    if Pos('cmdvrt32.dll',Modules.Strings[i]) <> 0  then
      Is_Sandboxed := True;
  end;

  if Is_Sandboxed then
   MessageBox(self.Handle,'Sandbox Detected','Error',MB_ICONSTOP)
  else
   MessageBox(self.Handle,'Sandbox did not Detected','Info',MB_ICONINFORMATION);

  Modules.Free;
end;

end.
