unit uLFG3_Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Samples.Spin,
  Vcl.Imaging.jpeg,System.IOUtils, Vcl.Buttons , shellapi;
type
 TRGBArray = array[0..0] of TRGBTriple;
 pRGBArray = ^TRGBArray;
type
  TfrmLFG3Main = class(TForm)
    OpenDialog1: TOpenDialog;
    panelA: TPanel;
    IMG: TImage;
    btnLoadHex: TButton;
    btnImageToHEX: TButton;
    PageControl1: TPageControl;
    TabSheetBinary: TTabSheet;
    MemoBinary: TMemo;
    TabSheetHEX: TTabSheet;
    MemoHEX: TMemo;
    Panel1: TPanel;
    Button3: TButton;
    Button2: TButton;
    SaveDialog1: TSaveDialog;
    Panel2: TPanel;
    Button4: TButton;
    Button5: TButton;
    SpinEditWidth: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    SpinEditHeight: TSpinEdit;
    ImageRAW: TImage;
    Button6: TButton;
    Button7: TButton;
    TrackBar1: TTrackBar;
    ImageOpenedOrigin: TImage;
    TrackBar2: TTrackBar;
    Label3: TLabel;
    Label4: TLabel;
    TabSheet1: TTabSheet;
    Image1: TImage;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    BitBtn1: TBitBtn;
    Image2: TImage;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    BitBtn2: TBitBtn;
    Label17: TLabel;
    BitBtn3: TBitBtn;
    btnBinToHex: TBitBtn;
    procedure btnLoadHexClick(Sender: TObject);
    procedure btnImageToHEXClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure SpinEditWidthChange(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure Label6Click(Sender: TObject);
    procedure Label13Click(Sender: TObject);
    procedure btnBinToHexClick(Sender: TObject);
    procedure IMGMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure IMGMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure IMGMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
      LeftDown , RightDown : Boolean ;
  public
    
  end;
const
  OLEDH_URL = 'https://elvand.com/oledh/';
  LFG_URL   = 'https://elvand.com/lcd-font-generator-lfg/';
var
  frmLFG3Main: TfrmLFG3Main;

implementation

{$R *.dfm}
//==================================================================================================
function getlocaltempdir : string ;
begin
  Result := System.IOUtils.TPath.GetTempPath ;
  if not DirectoryExists(result) then ShowMessage('Sorry this path not found :'+#13+Result+'Please run application as administrator');  
  if result[length(result)] <> '\' then result := result + '\';
  
end;

procedure Jpeg2Bmp(const BmpFileName, JpgFileName: string); // helloacm.com
var
  Bmp: TBitmap;
  Jpg: TJPEGImage;
begin
  Bmp := TBitmap.Create;
  Bmp.PixelFormat := pf1bit;
  Jpg := TJPEGImage.Create;
  try
    Jpg.LoadFromFile(JpgFileName);
    Bmp.Assign(Jpg);
    Bmp.SaveToFile(BmpFileName);
  finally
    Jpg.Free;
    Bmp.Free;
  end;
end;

function MyHexToBin(HexStr: string): string;
const
  BinArray: array[0..15, 0..1] of string =
    (('0000', '0'), ('0001', '1'), ('0010', '2'), ('0011', '3'),
     ('0100', '4'), ('0101', '5'), ('0110', '6'), ('0111', '7'),
     ('1000', '8'), ('1001', '9'), ('1010', 'A'), ('1011', 'B'),
     ('1100', 'C'), ('1101', 'D'), ('1110', 'E'), ('1111', 'F'));
  HexAlpha: set of char = ['0'..'9', 'A'..'F'];
var
  i, j: Integer;
begin
  Result:='';
  HexStr:=AnsiUpperCase(HexStr);
  for i:=1 to Length(HexStr) do
    if HexStr[i] in HexAlpha then
    begin
      for j:=1 to 16 do
        if HexStr[i]=BinArray[j-1, 1] then
          Result:=Result+BinArray[j-1, 0];
    end
    else
    begin
      Result:='';
      ShowMessage('This is not hexadecimal number');
      Break;
    end;
  if Result<>'' then
//   while (Result[1]='0')and(Length(Result)>1) do
//     Delete(result, 1, 1);
end;
//==================================================================================================
function MyBinToHex(BinStr: string): string;
const
  BinArray: array[0..15, 0..1] of string =
    (('0000', '0'), ('0001', '1'), ('0010', '2'), ('0011', '3'),
     ('0100', '4'), ('0101', '5'), ('0110', '6'), ('0111', '7'),
     ('1000', '8'), ('1001', '9'), ('1010', 'A'), ('1011', 'B'),
     ('1100', 'C'), ('1101', 'D'), ('1110', 'E'), ('1111', 'F'));
var
  Error: Boolean;
  j: Integer;
  BinPart: string;
begin
  Result:='';

  Error:=False;
  for j:=1 to Length(BinStr) do
    if not (BinStr[j] in ['0', '1']) then
    begin
      Error:=True;
      ShowMessage('This is not binary number');
      Break;
    end;

  if not Error then
  begin
    case Length(BinStr) mod 4 of
      1: BinStr:='000'+BinStr;
      2: BinStr:='00'+BinStr;
      3: BinStr:='0'+BinStr;
    end;

    while Length(BinStr)>0 do
    begin
      BinPart:=Copy(BinStr, Length(BinStr)-3, 4);
      Delete(BinStr, Length(BinStr)-3, 4);
      for j:=1 to 16 do
        if BinPart=BinArray[j-1, 0] then
          Result:=BinArray[j-1, 1]+Result;
    end;
  end;
end;
//==================================================================================================
Function HexStringToBinary(HexStr : String) : WideString ;
var
  po : Integer ;
  Hstr,str : String ;
begin
  HStr := HexStr ;
  str := '';
  po := pos('0x',HexStr) ;
  while po > 0  do
    begin
      str := str +  MyHexToBin(copy(HStr , 3 , 2)) ;
      HStr := trim(Copy(HStr , po+5 , length(HStr)));
      po := pos('0x',HStr) ;
    end;
  result := str ;
end;
//==================================================================================================
Function BinaryToHexString(BinStrAll : String;LastLine:Boolean) : String ;
var
  po : Integer ;
  str,binPart : String ;
begin
  str := BinStrAll ;
  result := '';
  while length(str)>=8 do
  begin
    binPart := copy(str,1,8);
//    while length(binPart)<8 do binPart := '0'+binPart ;
    result := result + '0x'+MyBinToHex(binPart)+',';
    if LastLine then
      if length(str)<=8 then result := copy(Result,1,length(result)-1);

    str := copy(str,9,length(str));
  end;
end;
procedure ShrinkBitmap(Bitmap: TBitmap; const NewWidth, NewHeight: integer);
begin
  Bitmap.Canvas.StretchDraw(
    Rect(0, 0, NewWidth, NewHeight),
    Bitmap);
  Bitmap.SetSize(NewWidth, NewHeight);
end;
function IntToByte(i : integer) : byte;
begin
if (i>255) then
Result := 255
else if (i < 0) then
Result := 0
else
Result := i;
end;
procedure MyBrightness(Src : TBitmap; Amount : integer);
var
x, y : integer;
SrcLine : pRGBArray;
SrcGap : integer;
begin
Src.PixelFormat := pf24bit;
SrcLine := Src.ScanLine[0];
SrcGap := Integer(Src.ScanLine[1]) - Integer(SrcLine);
{$ifopt R+} {$define RangeCheck} {$endif} {$R-}
for y := 0 to pred(Src.Height) do begin
for x := 0 to pred(Src.Width) do begin
SrcLine[x].rgbtRed := IntToByte(SrcLine[x].rgbtRed +
MulDiv(SrcLine[x].rgbtRed, Amount, 100));
SrcLine[x].rgbtGreen := IntToByte(SrcLine[x].rgbtGreen +
MulDiv(SrcLine[x].rgbtGreen, Amount, 100));
SrcLine[x].rgbtBlue := IntToByte(SrcLine[x].rgbtBlue +
MulDiv(SrcLine[x].rgbtBlue, Amount, 100));
end; {for}
SrcLine := pRGBArray(Integer(SrcLine) + SrcGap);
end; {for}
{$ifdef RangeCheck} {$R+} {$undef RangeCheck} {$endif}
end; {Brightness}
{--------------------------------------------------------------------------------------------------}
procedure MyContrast(Src : TBitmap; Amount : integer);
var
x, y : integer;
r, g, b : integer;
rr, gg, bb : integer;
SrcLine : pRGBArray;
SrcGap : integer;
begin
Src.PixelFormat := pf24bit;
SrcLine := Src.ScanLine[0];
SrcGap := Integer(Src.ScanLine[1]) - Integer(SrcLine);
{$ifopt R+} {$define RangeCheck} {$endif} {$R-}
for y := 0 to pred(Src.Height) do begin
for x := 0 to pred(Src.Width) do begin
r := SrcLine[x].rgbtRed;
g := SrcLine[x].rgbtGreen;
b := SrcLine[x].rgbtBlue;
rr := MulDiv(abs(127-r), Amount, 100);
gg := MulDiv(abs(127-g), Amount, 100);
bb := MulDiv(abs(127-b), Amount, 100);
if (r>127) then
r := r+rr
else
r := r-rr;
if (g>127) then
g := g+gg
else
g := g-gg;
if (b>127) then
b := b+bb
else
b := b-bb;
SrcLine[x].rgbtRed := IntToByte(r);
SrcLine[x].rgbtGreen := IntToByte(g);
SrcLine[x].rgbtBlue := IntToByte(b);
end; {for}
SrcLine := pRGBArray(Integer(SrcLine) + SrcGap);
end; {for}
{$ifdef RangeCheck} {$R+} {$undef RangeCheck} {$endif}
end; {Contrast}
//==================================================================================================
//==================================================================================================
//==================================================================================================
procedure TfrmLFG3Main.BitBtn3Click(Sender: TObject);
begin
    ShellExecute(0, nil, PChar(String(OLEDH_URL)), nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmLFG3Main.btnLoadHexClick(Sender: TObject);
var
  ss : Tstrings ;
  I,J: Integer;
begin
 with MemoBinary do begin
 OpenDialog1.Filter:='Header Files|*.h|All Files|*.*';
// OpenDialog1.DefaultExt:='*.h';
 if OpenDialog1.Execute then
  begin
    PageControl1.ActivePageIndex := 0 ;
    IMG.Canvas.Brush.Color := clwhite ;
    MemoBinary.Clear;
    ss := TStringList.Create;
    try
      ss.LoadFromFile(OpenDialog1.FileName);
      //ss.LoadFromFile('d:\bitmap.h');
      Lines.Clear;
      for I := 11 to ss.Count-1 do
          Lines.Add(HexStringToBinary(ss[i]));
    finally
      ss.Free;
    end;
  end;
  for I := 1 to Lines.Count do
     for J := 1 to length(Lines[i]) do
      if Lines[i][j] = '1' then
       IMG.Canvas.Pixels[j,i] := clblack ;

  //IMG.Picture.SaveToFile('d:\img.bmp');
 end;
end;

//procedure TfrmLFG3Main.btnPatternGenClick(Sender: TObject);
//var
// I,J : Integer ;
//begin
// btnPatternGen.Enabled := false ;
// Application.ProcessMessages;
// try
//   setlength(PatternArray,0);
//   SetLength(PatternArray,IMG.Width,IMG.Height);
//   for I := 0 to IMG.Width-1 do
//    begin
//      for J := 0 to IMG.Height-1 do
//        begin
//           PatternArray[i,j] := TLabel.Create(self);
//           PatternArray[i,j].Parent := PanelPattern ;
//           PatternArray[i,j].font.Name := 'Wingdings 2';
//           PatternArray[i,j].Caption := '£';
//           PatternArray[i,j].Top := (J*10)+10;
//           PatternArray[i,j].Left := (I*10)+10;
//        end;
//    end;
// finally
//   btnPatternGen.Enabled := true ;
//   Application.ProcessMessages;
// end;
//end;

procedure TfrmLFG3Main.btnBinToHexClick(Sender: TObject);
var
  I: Integer;
  j: Integer;
begin
    MemoHEX.Clear;
      MemoHEX.Lines.Add('/*');
      MemoHEX.Lines.Add(' *');
      MemoHEX.Lines.Add(' *  Created on: '+DateTimeToStr(now));
      MemoHEX.Lines.Add(' *          by: OLEDH');
      MemoHEX.Lines.Add(' *     Website: www.elvand.com');
      MemoHEX.Lines.Add(' *');
      MemoHEX.Lines.Add(' *       Width: '+inttostr(IMG.Width));
      MemoHEX.Lines.Add(' *      Height: '+inttostr(IMG.Height));
      MemoHEX.Lines.Add(' */');
      MemoHEX.Lines.Add('');
      MemoHEX.Lines.Add('#ifndef BITMAP_H_');
      MemoHEX.Lines.Add('#define BITMAP_H_');
      MemoHEX.Lines.Add('');
      MemoHEX.Lines.Add('const unsigned char logo [] = {');
      
      for I := 0 to MemoBinary.Lines.Count-1 do
        MemoHEX.Lines.Add(BinaryToHexString(MemoBinary.Lines[i],i=MemoBinary.Lines.Count-1));

      MemoHEX.Lines.Add('};');
      MemoHEX.Lines.Add('');
      MemoHEX.Lines.Add('#endif /* BITMAP_H_ */');
      PageControl1.ActivePageIndex := 1 ;
end;

procedure TfrmLFG3Main.btnImageToHEXClick(Sender: TObject);
var
  I: Integer;
  j: Integer;
  ss : TStrings ;
begin
    PageControl1.ActivePageIndex := 0 ;
    MemoBinary.Clear;
    MemoHEX.Clear;
    ss := TStringList.Create;
    try
    for I := 1 to IMG.Height do
      for j := 1 to IMG.Width do
          if IMG.Canvas.Pixels[j,i]<>clWhite then IMG.Canvas.Pixels[j,i] := clblack;

    for I := 0 to IMG.Height-1 do
      begin
        ss.Add('');
        for j := 1 to IMG.Width do
           if IMG.Canvas.Pixels[j,i]=clBlack
            then ss[i] :=ss[i] +'1'
            else ss[i] :=ss[i] +'0';
      end;
      MemoBinary.Lines := ss ;
      MemoHEX.Lines.Add('/*');
      MemoHEX.Lines.Add(' *');
      MemoHEX.Lines.Add(' *  Created on: '+DateTimeToStr(now));
      MemoHEX.Lines.Add(' *          by: OLEDH');
      MemoHEX.Lines.Add(' *     Website: www.elvand.com');
      MemoHEX.Lines.Add(' *');
      MemoHEX.Lines.Add(' *       Width: '+inttostr(IMG.Width));
      MemoHEX.Lines.Add(' *      Height: '+inttostr(IMG.Height));
      MemoHEX.Lines.Add(' */');
      MemoHEX.Lines.Add('');
      MemoHEX.Lines.Add('#ifndef BITMAP_H_');
      MemoHEX.Lines.Add('#define BITMAP_H_');
      MemoHEX.Lines.Add('');
      MemoHEX.Lines.Add('const unsigned char logo [] = {');

      for I := 0 to ss.Count-1 do
        MemoHEX.Lines.Add(BinaryToHexString(ss[i],i=ss.Count-1));

      MemoHEX.Lines.Add('};');
      MemoHEX.Lines.Add('');
      MemoHEX.Lines.Add('#endif /* BITMAP_H_ */');

    finally
      ss.Free;
    end;

end;

procedure TfrmLFG3Main.Button2Click(Sender: TObject);
begin
  SaveDialog1.Filter:='Bitmap Binary Files|*.0101|All Files|*.*';
  SaveDialog1.DefaultExt:='*.0101';
   if SaveDialog1.Execute then MemoBinary.Lines.SaveToFile(SaveDialog1.FileName);
end;

procedure TfrmLFG3Main.Button3Click(Sender: TObject);
begin
  OpenDialog1.Filter:='Bitmap Binary Files|*.0101|All Files|*.*';
   if OpenDialog1.Execute then MemoBinary.Lines.LoadFromFile(OpenDialog1.FileName);
end;

procedure TfrmLFG3Main.Button4Click(Sender: TObject);
begin
  OpenDialog1.Filter:='Bitmap Hex Files|*.h|All Files|*.*';
   if OpenDialog1.Execute then MemoHEX.Lines.LoadFromFile(OpenDialog1.FileName);
end;

procedure TfrmLFG3Main.Button5Click(Sender: TObject);
begin
  SaveDialog1.Filter:='Bitmap Hex Files|*.h|All Files|*.*';
  SaveDialog1.DefaultExt:='*.h';
   if SaveDialog1.Execute then MemoHEX.Lines.SaveToFile(SaveDialog1.FileName);

end;

procedure TfrmLFG3Main.Button6Click(Sender: TObject);
begin
  SaveDialog1.Filter:='Bitmap Files|*.bmp|All Files|*.*';
  SaveDialog1.DefaultExt := '*.bmp';;
  if SaveDialog1.Execute then IMG.Picture.SaveToFile(SaveDialog1.FileName);
end;


procedure TfrmLFG3Main.Button7Click(Sender: TObject);
begin
  OpenDialog1.Filter:='Images|*.jpg;*.bmp|Bitmap Files|*.bmp|Jpeg Files|*.jpg|All Files|*.*';
  if OpenDialog1.Execute then with IMG do
  begin
    MemoBinary.Lines.clear;
    if Uppercase(ExtractFileExt(OpenDialog1.FileName))='.BMP' then
    begin
      Picture.LoadFromFile(OpenDialog1.FileName);
      ShrinkBitmap(IMG.Picture.Bitmap , SpinEditWidth.Value,SpinEditHeight.Value);
      ImageOpenedOrigin.Picture := IMG.Picture ;
    end;
    if Uppercase(ExtractFileExt(OpenDialog1.FileName))='.JPG' then
    begin
      Jpeg2Bmp(getlocaltempdir+'oled_temp.bmp',OpenDialog1.FileName);
      Picture.LoadFromFile(getlocaltempdir+'oled_temp.bmp');
      ShrinkBitmap(IMG.Picture.Bitmap , SpinEditWidth.Value,SpinEditHeight.Value);
      ImageOpenedOrigin.Picture := IMG.Picture ;
    end;
    btnImageToHEXClick(btnImageToHEX);
  end;
end;

procedure TfrmLFG3Main.FormCreate(Sender: TObject);
begin
  LeftDown := false ;
  RightDown := false ;
end;

procedure TfrmLFG3Main.FormShow(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0 ;
end;

procedure TfrmLFG3Main.IMGMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,Y: Integer);
begin
  if Button = mbleft then begin
      IMG.Canvas.Pixels[X,Y]:=clBlack ;
      LeftDown := true;
  end;
  if Button = mbRight then begin
      IMG.Canvas.Pixels[X,Y]:=clwhite ;
      RightDown := true;
  end;
end;

procedure TfrmLFG3Main.IMGMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if leftdown then  IMG.Canvas.Pixels[X,Y]:=clBlack ;
  if Rightdown then  IMG.Canvas.Pixels[X,Y]:=clWhite ;  
end;

procedure TfrmLFG3Main.IMGMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    RightDown := false;  
    LeftDown := false;
end;

procedure TfrmLFG3Main.Label13Click(Sender: TObject);
begin
ShellExecute(0, nil, PChar(String(LFG_URL)), nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmLFG3Main.Label6Click(Sender: TObject);
begin
  ShellExecute(0, nil, PChar(String(OLEDH_URL)), nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmLFG3Main.SpinEditWidthChange(Sender: TObject);
begin
  IMG.Picture := ImageRAW.Picture;
  ShrinkBitmap(IMG.Picture.Bitmap , SpinEditWidth.Value,SpinEditHeight.Value);
  if SpinEditWidth.Value>=128 then
    panelA.Width := SpinEditWidth.Value+50 ;
end;

procedure TfrmLFG3Main.TrackBar1Change(Sender: TObject);
begin
  IMG.Picture := ImageOpenedOrigin.Picture ;
  MyBrightness(IMG.Picture.Bitmap,TrackBar1.Position);
  IMG.Refresh;
end;

procedure TfrmLFG3Main.TrackBar2Change(Sender: TObject);
begin
  IMG.Picture := ImageOpenedOrigin.Picture ;
  MyContrast(IMG.Picture.Bitmap,TrackBar2.Position);
  IMG.Refresh;
end;

end.
