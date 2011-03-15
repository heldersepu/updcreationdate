{**
Program will updated the creation date to
match the date modified to all the files
in a given directory
**}

program UpdCreationDate;
{$APPTYPE CONSOLE}
uses
  SysUtils;
var
  I: Integer;
  showFiles: Boolean;
  strFolderName: string;

procedure ShowHelp;
begin
  writeln(' ');
  writeln('Update the created date with the values of the date modified.');
  writeln(' ');
  writeln(' USAGE: UpdCreationDate <Dir-To_Modify> [-d]');
  writeln('   -d to display the file processed');
  writeln(' ');
end;

procedure updateCreationDate(strFolderName: String; showFiles: Boolean);
begin
  {ToDO add logic to update the Creation Date}
end;

begin
  if (ParamCount = 0) then
    ShowHelp
  else
  begin
    if (Pos(ParamStr(1), '/?') > 0) then
      ShowHelp
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
        ShowHelp
      end;

    end;
  end;
end.
