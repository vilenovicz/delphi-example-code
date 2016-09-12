unit uUtils;

interface
uses classes;
var
  List:TStrings;


function PosEx(SubStr,Str:string;BeginCh:integer=1):integer;
function PosExA(SubStr,Str:string;SubStrIdx:integer):integer;
function PosRev(Substr,Str:string;BeginCh:integer):integer;


implementation
//******************
function PosExA(SubStr,Str:string;SubStrIdx:integer):integer;
{
  �-��� ���� SubStrIdx-��� ��������� ������ SubStr � ������ Str
  �� ������� - ������� 0
}
var
  i,//��� �����
  k,//��� �������� ���� ���������
  tmp:integer;
  s:string;
begin
  tmp:=0;
  k:=0;
  for i:=1 to Length(Str) do
  begin
    s:=copy(Str,i,Length(SubStr));
    if s=SubStr then
    begin
      k:=k+1;
      if k=SubStrIdx then
      begin
        tmp:=i;
        break;
      end;
    end;
  end;
  result:=tmp;
end;

//*******************



//-------------
function PosEx(SubStr,Str:string;BeginCh:integer=1):integer;
{
  ������� ���� ��������� ������ SubStr � ������ Str, ������� � BeginCh.
  ���� ������ �� �������, ���������� 0;
}
var
  i,tmp:integer;
begin
  tmp:=0;
  for i:=BeginCh to Length(Str)-1 do
  begin
    if copy(Str,i,length(SubStr))=SubStr then
    begin
      tmp:=i;
      break;
    end;
  end;
  result:=tmp;
end;

//-----------------
function PosRev(SubStr,Str:string;BeginCh:integer):integer;
{
  ������� ���� ��������� ������ SubStr � ������ Str, ������� � BeginCh,
  �������� � �������� �����������.
  ���� ������ �� �������, ���������� 0.

}
var
  i,tmp:integer;
begin
  tmp:=0;
  for i:=BeginCh downto 0 do
  begin
    if copy(Str,i,length(SubStr))=SubStr then
    begin
      tmp:=i;
      break;
    end;
  end;
  result:=tmp;
end;
end.
