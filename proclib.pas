unit proclib;
{
���.�� 070501
(+) ��������� overload ��������� DevideStringToToken,
    � ������� ������������ ������ ������������� �������
(!) ���������� ��� �� ��������� - ������ ���������� � 1-�� ��������    


}
interface
uses SysUtils,rxStrUtils,uUtils,registry,StrUtils,classes;

Type
{����� � �����������}
  TToken = string;
  TTokenList = array of TToken;



//***
{������, ���� ����� ������ idx ������������ � ������ ������������ MadeList}
function InMadeList(idx:integer;MadeList:TStringList):boolean;

//***
{��������� ���� �� ���� - 00.00.0000, ���� ���, �� ������� ����, ���������
� newdate. �� ��������� 01.01.2000}
function CheckDate(date:string;newdate:string='01.01.2000'):string;
//***

//***
{������ ���� �������� ������� ��� � �����}
function IsAlreadyArab(ser:string):boolean;
//***

//***
{����������� num ������� �� ������� surname
������� ��������� delim
}
function DoubleSurname(surname:string;delim:string;num:integer):string;
//***

//***
{
  ���������� �������� �������� ������, �������� ������
}
function MonthToDig(month:string):string;
//***

//***
{
  ����������� ������� ������ ������ � ���
  ������,�������,����� �,����� ��,���,������,��������
  ����: �.�����, ������� �������, ��.�����, ���-��
}
function Z2Addr(addr:string):string;
//***

//***
{
  ��������� ������ �� ������ (�������), �������� ���������� ������ ����,
  ������� ������ ������������.
}
procedure DevideStringToToken(str:string;delimiter:char;out TokenList:TTokenList);overload;
procedure DevideStringToToken(str:string;delimiter:char;out TokenList:TTokenList; out TokenListSize:integer);overload;

//***

//***
{
  ������ ������� ���� � �����������
}
function InvertToken(str:string;delimiter:char):string;
//***
//****
{
  ������� ��������� ������� �� ������
}
function DelCharFromDig(str:string):string;
//****

//*******
{
  ��������������� �������� �� �������
}
procedure LoadParam(local,reg:integer);
//*******

//*******
{
  ��������� �������� � ������
}
//procedure SaveParam(local,reg:integer);
//*******

//*******
{
  ���� ����� str1+str2 ������ 25 ��������, �� ��������� str1
}

function Digit25(str1,str2:string):string;overload;
//*******

//*******
{
  �� - ���� ������� ������ �������� ���� �������
  ��� - ���� �� ��������� ������ ���� �����
}
function IsAlpha(str:string):boolean;
//*******

//*******
{
  ���������� �� ����, ��������� �� ���� �����
  doc_s � doc_n - ����� � ������ ���������
  ���� ����� ���-�� ������� �� ����� ����, �� ��� �� �������� = 21 ����,
  ���� � ����� ���������� �����, �� ��� ��. �������� = 01 ������, � � ����
  ������ ����� ����� ������� ����������� � �������.
}
function MakeUdLichn(ser,num:string):string;
//*******

//*******
{
  ���������
  kod=510 -> ��������
  kod=520 -> ��������
  kod=561 -> ���������
  kod=540 -> ��������
}
function TypeTrans(kod:string):string;
//*******

//*******
//���������� 19?? ���� ������� ���= 2 �����, 200?, ���� ������� ��� = 1 ����
function God_V(god_from_table:string):string;
//*******

//*******
// �������� ����� ����� ��� ���������� �������� ���� file.bak
function MakeBackupFileName(OldFN:string;NewExt:string):string;
//*******

//*******
// ��������� �������� ����� � �������.
// ����� ������ ���� <=39.
function Arab2Rome(Arab:integer):string;overload;
//function Arab2Rome(Arab:string):string;overload;
//*******

//*******
{
  ����� ��������� fill_ch � ������ str ��� ��������� char_cnt ��������
  ���������� ������. ��������, padl('11',5,'0') ������ 00011;
}

function padl(str:string;char_cnt:integer;fill_ch:char):string;
//*******

//*******
{
  ���������� 1, ���� �������� father_name �������,
    0, ���� �������,
    -1 ���� ���������� �� �������.
}
//*******

//*******
function mw(father_name:string):integer;
{
  ������ �, ���� mw = 1
    �, ���� mw = 0
    -, ���� mw = -1;
}
//*******

//*******
function AnalyseMW(mw:integer):string;overload;
function AnalyseMW(mw:string):string;overload;
//*******

//*******
{ ���� ����� ������, �� �� ��������� ������,
  ����� - punct �
}
function GetPunct(punct:string):string;
//*******

//*******
//�������� �������� �� ������� ��� - ������� �.�.
function GetInitials(full_fio:string):string;
//*******

implementation

//---------
procedure SaveIntParam(local:integer;param:string);
var
  reg:TRegistry;
begin
  reg:=TRegistry.Create;
//  reg.RootKey:=HKEY_LOCAL_MACHINE;
  try
    if reg.OpenKey('\IT\PVS',true) then
    begin
      reg.WriteInteger(param,local);
      reg.CloseKey;
    end
  except
//    ShowMessage('������ ���������� ����������');
  end;
  reg.Free;
end;
//---------
//----------
function ReadParam(param:string):integer;
var
  reg:TRegistry;
  tmp:integer;
begin
  tmp:=0;
  reg:=TRegistry.Create;
//  reg.RootKey:=HKEY_LOCAL_MACHINE;
  try
    if reg.OpenKey('\IT\PVS',false) then
    begin
      tmp:=reg.ReadInteger(param);
      reg.CloseKey;
    end;
  except
  end;
  reg.Free;
  result:=tmp;
end;
//-------

//--------
function GetPunct(punct:string):string;
var
  tmp:string;
begin
  tmp:='';
  if punct<>'' then
  begin
    if (Pos('�.',punct)>0) or (Pos('�.',punct)>0) then
      tmp:=copy(punct,3,Length(punct)-2)+ ' �'
    else
      tmp:=punct + ' �';
  end;
  result:=tmp;
end;

//--------

//---
function IsAlreadyArab(ser:string):boolean;
var
  tmp:boolean;
begin
  if (Pos('I',ser)>0) or
    (Pos('V',ser)>0) or
    (Pos('X',ser)>0) then
      tmp:=true
  else
    tmp:=false;
  result:=tmp;
end;
//---
//--------
function IsAlpha(str:string):boolean;
var
  tmp:boolean;
  i:integer;
begin
  tmp:=false;
  for i:=1 to Length(str) do
  begin
    if str[i] in ['0'..'9'] then
    begin
    end
    else
    begin
      if str[i]=' ' then
      begin
      end
      else
      begin
        tmp:=true;
        break;
      end;
    end;
  end;
  result:=tmp;
end;
//---------



//-----------
function MakeUdLichn(ser,num:string):string;
var
  tmp:string;
begin
  tmp:='';
  if (ser='') and (num='') then
  begin
    result:='91,0';
    exit;
  end;
  try
    if not IsAlpha(ser) then
    begin
      if Pos(' ',ser)=0 then
        tmp:='21,'+LeftStr(ser,length(ser)-2)+' '+RightStr(ser,2)+' '+padl(num,6,'0')
      else
        tmp:='21,'+ser+' '+padl(num,6,'0');
    end
    else
      if not IsAlreadyArab(ser) then
        tmp:='01,'+Arab2Rome(StrToInt(LeftStr(ser,length(ser)-2)))+'-'+RightStr(ser,2)+' '+padl(num,6,'0')
      else
        tmp:='01,'+ser+' '+num;
  except
    tmp:='91,'+ser+' '+num;
  end;
  result:=tmp;
end;
//-----------


//--------------
function TypeTrans(kod:string):string;
var
  tmp:string;
begin
  tmp:='';
  if kod='510' then tmp:='��������';
  if kod='520' then tmp:='��������';
  if kod='561' then tmp:='���������';
  if kod='540' then tmp:='��������';
  result:=tmp;

end;
//--------------

//-----
function DelCharFromDig(str:string):string;
var
  i:integer;
  tmp:string;
begin
  tmp:='';
  for i:=1 to Length(str) do
  begin
    if str[i] in ['0'..'9'] then
      tmp:=tmp+str[i];
  end;
  result:=tmp;
end;
//-----
//-------------
function God_V(god_from_table:string):string;
var
  tmp:string;
  god:string;
begin
  god:=DelCharFromDig(god_from_table);
  tmp:='';
  if Length(god)=1 then
    tmp:='200'+god
  else
    if Length(god)=2 then
      tmp:='19'+god
    else
      tmp:=god;
  result:=tmp;
end;
//--------------



//------------------------
function MakeBackupFileName(OldFN:string;NewExt:string):string;
begin
   Result:=ReplaceStr(OldFN,ExtractFileExt(OldFN),NewExt);
end;
//-------------------------

//-------------------------
function Edin(ostatok:integer):string;
// ������� ����� ������
var
  tmp:string;

  function Fill(povtor:integer):string;
  // ��������� ������� �� ������� �����
  // 8 - VIII
  var
    j:integer;
    tmp:string;
  begin
    for j:=1 to povtor do
      tmp:=tmp+'I';
    result:=tmp;
  end;

begin
  if ostatok<5 then
    tmp:=Fill(ostatok)
  else
    if ostatok=5 then
      tmp:='V';
    if ostatok>5 then
      tmp:='V'+Fill(ostatok-5);
    if ostatok=9 then
      tmp:='IX';
    if ostatok=4 then
      tmp:='IV';

  result:=tmp;
end;

//---------
function Arab2Rome(Arab:integer):string;overload;
var
  des:integer; //���-�� ��������
  Rome:string;
  i:integer;
begin
  des:=Arab div 10;
  for i:=1 to des do
  begin
    Rome:=Rome+'X';
  end;
  Rome:=Rome+Edin(Arab mod 10);
  result:=Rome;
end;
//--------------------------

//---------
{
function Arab2Rome(Arab:string):string;overload;
var
  des:integer; //���-�� ��������
  Rome:string;
  i:integer;
begin
  des:=Arab div 10;
  for i:=1 to des do
  begin
    Rome:=Rome+'X';
  end;
  Rome:=Rome+Edin(Arab mod 10);
  result:=Rome;
end;
//--------------------------
}

//--------------------------
function padl(str:string;char_cnt:integer;fill_ch:char):string;
var
  i:integer;
  tmp:string;
begin
  tmp:='';
  for i:=0 to char_cnt-length(str)-1 do
  begin
    tmp:=tmp+fill_ch;
  end;
  result:=tmp+str;
end;
//---------------------------

//---------------------------
function mw(father_name:string):integer;
var
  tmp:integer;
  okonch:string;
begin
  okonch:=ansilowercase(copy(father_name,Length(father_name)-1,2));
  tmp:=-1;
  if (okonch='��') or (okonch='��') then
    tmp:=1
  else
    if (okonch='��') or (okonch='��')then
      tmp:=2;
  result:=tmp;
end;
//---------------------------

//----------------------------
function AnalyseMW(mw:integer):string;
var
  tmp:string;
begin
  case mw of
    1:tmp:='1';
    0:tmp:='2';
    -1:tmp:='-';
  end;
  result:=tmp;
end;

function AnalyseMW(mw:string):string;overload;
var
  tmp:string;
begin
  if (mw='�') or (mw = '���.') then
    tmp:='1';
  if (mw='�') or (mw = '���.') then
    tmp:='2';
  result:=tmp;
end;

//----------------------------

//**************
function GetInitials(full_fio:string):string;
var
  tmp:string;
  i:integer;
begin
  tmp:='';
  i:=Pos(' ',full_fio);
  tmp:=copy(full_fio,0,i)+
    copy(full_fio,i,2)+'.'+
    copy(full_fio,PosEx(' ',full_fio,i+1),2)+'.';
  result:=tmp;
end;
//**************
//---
function Digit25(str1,str2,str3:string):string;overload;
var
  tmp:string;
begin
  if Length(str1+'-'+str2+ '('+str3+')')>24 then
    tmp:=str1
  else
    if str2<>'' then
      tmp:=str1+'-'+str2+'('+str3+')'
    else
      tmp:=str1;
  result:=tmp;
end;
//---
//---------
function Digit25(str1,str2:string):string;
var
  tmp:string;
begin
  if Length(str1+'-'+str2)>24 then
    tmp:=str1
  else
    if str2<>'' then
    begin
      if Pos('���',str1)=0 then
        tmp:=str1+'-'+str2
      else
        tmp:=str1+' '+str2
    end
    else
      tmp:=str1;
  result:=tmp;
end;
//---------

//---------
procedure LoadParam(local,reg:integer);
var
  regs:TRegistry;
begin
  regs:=TRegistry.Create;
//  regs.RootKey:=HKEY_CURRENT_MACHINE;
  if regs.OpenKey('IT\pvs',true) then
  begin
//    local:=regs.ReadInteger(regs);
  end
end;
//---------

//---
function InvertToken(str:string;delimiter:char):string;
var
  tmp:string;
  token:TToken;
  i:integer;
  delim_cnt,curr_token:integer;
  TokenList:TTokenList;
begin
  tmp:='';
  token:='';
  curr_token:=0;
  delim_cnt:=0;
  //���������� �� ��������� ��������
  str:=Trim(str);
  //���������� ����� ������������, -> ���� �����_����+1
  for i := 0  to Length(str)-1 do
  begin
    if str[i]=delimiter then
      delim_cnt:=delim_cnt+1;
  end;
  SetLength(TokenList,delim_cnt+1);
  for i:=1  to Length(str) do
  begin
    if str[i]<>delimiter then
      token:=token+str[i]
    else
    begin
      curr_token:=curr_token+1;
      TokenList[delim_cnt+1-curr_token]:=token;
      token:='';
    end
  end;
  //��� ���������� �����
  curr_token:=curr_token+1;
  TokenList[delim_cnt+1-curr_token]:=token;
  for i:=0 to delim_cnt do
  begin
    tmp:=tmp+TokenList[i]+delimiter;
  end;
  result:=tmp;
end;
//---

//---
function Z2Addr(addr:string):string;
{
var
  tmp:string;
  TokenList:TTokenList;

  _beg,_end:integer;
  strana,obl,gor,punct,dom,korpus,kv:string;
}
begin
{
  DevideStringToToken(addr,' ',TokenList);

  _beg:=Pos('�.',addr);
  _end:=Pos(' ',addr);
  gor:=copy(addr,_beg,_end-_beg);
  _beg:=PosEx(' ',addr,Pos('gor',addr)+1);
  _end:=Pos('�������',addr);
  obl:=copy(addr,_beg,_end-_beg);
  _beg:=Pos('��.',addr);
}

end;
//---

//---
procedure DevideStringToToken(str:string;delimiter:char;out TokenList:TTokenList;out TokenListSize:integer);overload;
var
  tmp:string;
  token:TToken;
  i:integer;
  delim_cnt,curr_token:integer;
begin
  tmp:='';
  token:='';
  curr_token:=0;
  delim_cnt:=0;
  //���������� �� ��������� ��������
  str:=Trim(str);
  //���������� ����� ������������, -> ���� �����_����+1
  for i := 0  to Length(str) do
  begin
    if str[i]=delimiter then
      delim_cnt:=delim_cnt+1;
  end;
  SetLength(TokenList,delim_cnt+2);
  for i:=1  to Length(str) do
  begin
    if str[i]<>delimiter then
      token:=token+str[i]
    else
    begin
//      TokenList[delim_cnt+1-curr_token]:=token;
      TokenList[curr_token]:=token;
      curr_token:=curr_token+1;
      token:='';
    end
  end;

  //��� ���������� �����
//  curr_token:=curr_token+1;
//      TokenList[delim_cnt+1-curr_token]:=token;
  TokenList[curr_token]:=token;
  
  TokenListSize:=delim_cnt+2;
end;


procedure DevideStringToToken(str:string;delimiter:char;out TokenList:TTokenList);
var
  tmp:string;
  token:TToken;
  i:integer;
  delim_cnt,curr_token:integer;
begin
  tmp:='';
  token:='';
  curr_token:=0;
  delim_cnt:=0;
  //���������� �� ��������� ��������
  str:=Trim(str);
  //���������� ����� ������������, -> ���� �����_����+1
  for i := 0  to Length(str)-1 do
  begin
    if str[i]=delimiter then
      delim_cnt:=delim_cnt+1;
  end;
  SetLength(TokenList,delim_cnt+2);
  for i:=1  to Length(str) do
  begin
    if str[i]<>delimiter then
      token:=token+str[i]
    else
    begin
//      TokenList[delim_cnt+1-curr_token]:=token;
      TokenList[curr_token]:=token;
      curr_token:=curr_token+1;
      token:='';
    end
  end;
  //��� ���������� �����
//  curr_token:=curr_token+1;
//      TokenList[delim_cnt+1-curr_token]:=token;
  TokenList[curr_token]:=token;
end;
//---

//---
function MonthToDig(month:string):string;
var
  tmp:string;
begin
  tmp:='-1';
  if Pos('���',month)>0 then
    tmp:='01';
  if Pos('���',month)>0 then
    tmp:='02';
  if Pos('���',month)>0 then
    tmp:='03';
  if Pos('���',month)>0 then
    tmp:='04';
  if (Pos('���',month)>0) or
     (Pos('���',month)>0) then
    tmp:='05';
  if Pos('���',month)>0 then
    tmp:='06';
  if Pos('���',month)>0 then
    tmp:='07';
  if Pos('���',month)>0 then
    tmp:='08';
  if Pos('���',month)>0 then
    tmp:='09';
  if Pos('���',month)>0 then
    tmp:='10';
  if Pos('���',month)>0 then
    tmp:='11';
  if Pos('���',month)>0 then
    tmp:='12';
  result:=tmp;
end;
//---

//---
function DoubleSurname(surname:string;delim:string;num:integer):string;
var
  tmp:string;
  _start,_end:integer;
begin
  if num>2 then
  begin
    tmp:=surname;
    result:=tmp;
    exit;
  end;
  if Pos(delim,surname)=1 then
    surname:=copy(surname,2,Length(surname)-1);
  if Pos(delim,surname)>0 then
  begin
    if num=1 then
    begin
      _start:=1;
      _end:=Pos(delim,surname)-1;
    end
    else
    begin
      _start:=Pos(delim,surname)+1;
      _end:=Length(surname)-_start+1;
    end;
    tmp:=trim(copy(surname,_start,_end));
  end
  else
    tmp:=surname;
  result:=tmp;
end;
//---

//---
function CheckDate(date:string;newdate:string='01.01.2000'):string;
var
  tmp:string;
begin
  tmp:=date;
  if date='00.00.0000' then
    tmp:=newdate;
  result:=tmp;
end;
//---

function InMadeList(idx:integer;MadeList:TStringList):boolean;
var
  tmp:boolean;
  i:integer;
begin
  tmp:=false;
  for i:=0 to MadeList.Count-1 do
  begin
    if idx = StrToInt(copy(MadeList.Strings[i],1,Pos('=>>',MadeList.Strings[i])-1)) then
    begin
      tmp:=true;
      break;
    end;
  end;
  result:=tmp;
end;
//---

end.
