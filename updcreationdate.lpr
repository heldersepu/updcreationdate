program updcreationdate;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp, Windows,
  ColorUtils in 'ColorUtils.pas';
 var
  I: Integer;
  showFiles: Boolean;
  strFolderName: string;

type

  { TMyApplication }

  TMyApplication = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;


  function SetDateToFile(const FileName: string): Boolean;
  var
    hFile: THandle;
    FTimeC, FTimeA, FTimeM : TFileTime;
  begin
    Result := False;
    try
      hFile := FileOpen(FileName, fmOpenWrite or fmShareDenyNone);
      if (hFile > 0) then
      begin
        GetFileTime(hFile, @FTimeC, @FTimeA, @FTimeM);
        Result := SetFileTime(hFile, @FTimeM, @FTimeA, @FTimeM);
      end;
    finally
      FileClose(hFile);
    end;
  end;

  procedure updateCreationDate(strFolderName: String; showFiles: Boolean);
  var
    tSR : TSearchRec;
  begin
    if FindFirst(strFolderName + '\*.*', $20, tSR) = 0 then
    begin
      repeat
        if showFiles then
          Writeln(intToStr(tSR.Time) + '   ' + strFolderName + '\' + tSR.Name);
        if not SetDateToFile(strFolderName + '\' + tSR.Name) then
        begin
          ColorWrite(' Failed:   ',12); ColorWrite('' + tSR.Name,14,True);
        end;
      until (FindNext(tSR) <> 0);
    end;

    if FindFirst(strFolderName + '\*.*', faDirectory, tSR) = 0 then
    begin
      repeat
        If (Pos('.', tSR.Name) = 0) and (tSR.Attr <> 32) then
        begin
          if showFiles then
            ColorWrite('SubFolder: '+tSR.Name+' '+IntToStr(tSR.Attr),14,True);
          updateCreationDate(strFolderName + '\' + tSR.Name, showFiles);
        end;
      until (FindNext(tSR) <> 0);
    end;
  end;

procedure TMyApplication.DoRun;
var
  ErrorMsg: String;
begin
  if (ParamCount = 0) then
    WriteHelp
  else
  begin
    if (Pos(ParamStr(1), '/?') > 0) then
      WriteHelp
    else
    begin
      showFiles := False;
      strFolderName := '';
      for I := 1 to ParamCount do
      begin
        if UpperCase(ParamStr(I)) = '-D' then
          showFiles := True
        else
          if DirectoryExists(ParamStr(I)) then
            strFolderName := ParamStr(I);
      end;
      if strFolderName <> '' then
        updateCreationDate(strFolderName, showFiles)
      else
      begin
        writeln('   -d to display the file processed');
        writeln(' ');
        WriteHelp
      end;

    end;
  end;

  { add your program here }

  // stop program loop
  Terminate;
end;

constructor TMyApplication.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TMyApplication.Destroy;
begin
  inherited Destroy;
end;

procedure TMyApplication.WriteHelp;
begin
  writeln(' ');
  ColorWrite('Update the created date with the values of the date modified.',14,True);
  writeln(' ');
  writeln(' USAGE: UpdCreationDate <Dir-To_Modify> [-d]');
  writeln('   -d to display the file processed');
  writeln(' ');
end;

var
  Application: TMyApplication;
begin
  Application:=TMyApplication.Create(nil);
  Application.Title:='My Application';
  Application.Run;
  Application.Free;
end.

