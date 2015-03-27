unit UMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  UMetaData, UListView, UAboutProgram;

type

  { TMenuForm }

  TMenuForm = class(TForm)
    MainMenu: TMainMenu;
    ReferenceMenu: TMenuItem;
    AboutTheProgramMenu: TMenuItem;
    ExitMenu: TMenuItem;
    ModalWinControl: TWinControl;
    procedure AboutTheProgramMenuClick(Sender: TObject);
    procedure ExitMenuClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuItemClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  end;

var
  MenuForm: TMenuForm;

implementation

{$R *.lfm}

{ TMenuForm }

procedure TMenuForm.ExitMenuClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TMenuForm.AboutTheProgramMenuClick(Sender: TObject);
begin
  AboutProgramForm.Show;
end;

procedure TMenuForm.FormCreate(Sender: TObject);
var
  i: Integer;
  MenuItem: array of TMenuItem;

begin
  SetLength(MenuItem, Length(Table.TablesInf));
  SetLength(ListViewForm, Length(Table.TablesInf));

  for i := 0 to Length(Table.TablesInf) - 1 do
    begin
      MenuItem[i] := TMenuItem.Create(Self);
      With MenuItem[i] do
        begin
          Tag := i;
          Name := Table.TablesInf[i].Name;
          Caption := Table.TablesInf[i].Caption;
          OnClick := @MenuItemClick;
        end;
    end;

  ReferenceMenu.Add(MenuItem);
end;

procedure TMenuForm.MenuItemClick(Sender: TObject);
begin
  With (Sender as TMenuItem) do
    begin
      Checked := True;
      TListViewForm.CreateAndShowForm(Tag);
      ListViewForm[Tag].OnClose := @FormClose;
    end;
end;

procedure TMenuForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  ReferenceMenu[(Sender as TForm).Tag].Checked := False;
  ListViewForm[(Sender as TForm).Tag] := nil;
  CloseAction := caFree;
end;

end.

