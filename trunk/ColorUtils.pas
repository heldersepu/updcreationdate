unit ColorUtils;

interface
uses SysUtils, Windows;
  function getTextColor: Byte;
  procedure setTextColor(Color: Byte);
  procedure ColorWrite(strText: String; Color: Byte = 15; doEOL: Boolean = False);

implementation

  //Gets the Current console text color
  function getTextColor: Byte;
    var BufferInfo: TConsoleScreenBufferInfo;
  begin
    Rewrite(Output);
    GetConsoleScreenBufferInfo(TTextRec(Output).Handle, BufferInfo);
    getTextColor := BufferInfo.wAttributes;
  end;

  //Changes console text color
  procedure setTextColor(Color: Byte);
  begin
    SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), (Color and $0F));
  end;

  //Writes a line in color default color(White) & no EOL
  procedure ColorWrite(strText: String; Color: Byte = 15; doEOL: Boolean = False);
    var iniColor: Byte;
  begin
    //get initial color
    iniColor := getTextColor;
    //set the color
    setTextColor(Color);
    //Write the text
    if doEol then
      writeln(strText)
    else
      write(strText);
    //set the console back to the initial color
    setTextColor(iniColor);
  end;

end.
