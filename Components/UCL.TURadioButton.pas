﻿unit UCL.TURadioButton;

interface

uses
  UCL.Classes, UCL.TUThemeManager,
  System.Classes, System.SysUtils, System.Types,
  Winapi.Messages, Winapi.Windows,
  VCL.Controls, VCL.Graphics;

type
  TUCustomRadioButton = class(TGraphicControl, IUThemeControl)
    private var
      ICON_LEFT: Integer;
      TEXT_LEFT: Integer;

    private
      FThemeManager: TUThemeManager;

      FHitTest: Boolean;
      FIsChecked: Boolean;
      FGroup: string;
      FCustomActiveColor: TColor;
      FText: string;

      FIconFont: TFont;

      procedure SetThemeManager(const Value: TUThemeManager);
      procedure SetText(const Value: string);
      procedure SetIsChecked(const Value: Boolean);

      procedure WMLButtonUp(var Msg: TMessage); message WM_LBUTTONUP;

    protected
      procedure ChangeScale(M, D: Integer; isDpiChange: Boolean); override;
      procedure Paint; override;

    public
      constructor Create(aOwner: TComponent); override;
      procedure UpdateTheme;

    published
      property ThemeManager: TUThemeManager read FThemeManager write SetThemeManager;

      property HitTest: Boolean read FHitTest write FHitTest default true;
      property IsChecked: Boolean read FIsChecked write SetIsChecked default false;
      property Group: string read FGroup write FGroup;
      property CustomActiveColor: TColor read FCustomActiveColor write FCustomActiveColor;
      property Text: string read FText write SetText;

      property IconFont: TFont read FIconFont write FIconFont;
  end;

  TURadioButton = class(TUCustomRadioButton)
    published
      //  Common properties
      property Align;
      property Anchors;
      property Color;
      property Constraints;
      property DragCursor;
      property DragKind;
      property DragMode;
      property Enabled;
      property Font;
      property ParentFont;
      property ParentColor;
      property ParentShowHint;
      property PopupMenu;
      property ShowHint;
      property Touch;
      property Visible;

      //  Common events
      property OnClick;
      property OnContextPopup;
      property OnDblClick;
      property OnDragDrop;
      property OnDragOver;
      property OnEndDock;
      property OnEndDrag;
      property OnGesture;
      property OnMouseActivate;
      property OnMouseDown;
      property OnMouseEnter;
      property OnMouseLeave;
      property OnMouseMove;
      property OnMouseUp;
      property OnStartDock;
      property OnStartDrag;
  end;

implementation

{ THEME }

procedure TUCustomRadioButton.SetThemeManager(const Value: TUThemeManager);
begin
  if Value <> FThemeManager then
    begin
      //  Disconnect current ThemeManager
      if FThemeManager <> nil then
        FThemeManager.DisconnectControl(Self);

      //  Connect to new ThemeManager
      if Value <> nil then
        Value.ConnectControl(Self);

      FThemeManager := Value;
      UpdateTheme;
    end;
end;

procedure TUCustomRadioButton.UpdateTheme;
begin
  Paint;
end;

{ SETTERS }

procedure TUCustomRadioButton.SetIsChecked(const Value: Boolean);
begin
  if Value <> FIsChecked then
    begin
      FIsChecked := Value;
      UpdateTheme;
    end;
end;

procedure TUCustomRadioButton.SetText(const Value: string);
begin
  if Value <> FText then
    begin
      FText := Value;
      UpdateTheme;
    end;
end;

{ MAIN CLASS }

constructor TUCustomRadioButton.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);

  ICON_LEFT := 5;
  TEXT_LEFT := 35;

  FHitTest := true;
  FIsChecked := false;
  FCustomActiveColor := $D77800;
  FText := 'URadioButton';

  FIconFont := TFont.Create;
  FIconFont.Name := 'Segoe MDL2 Assets';
  FIconFont.Size := 15;

  Font.Name := 'Segoe UI';
  Font.Size := 10;

  Height := 30;
  Width := 200;
  ParentColor := true;

  Font.Name := 'Segoe UI';
  Font.Size := 10;

  //UpdateTheme;
  //  Dont UpdateTheme if it call Paint method
end;

{ CUSTOM METHODS }

procedure TUCustomRadioButton.ChangeScale(M: Integer; D: Integer; isDpiChange: Boolean);
begin
  inherited;

  ICON_LEFT := MulDiv(ICON_LEFT, M, D);
  TEXT_LEFT := MulDiv(TEXT_LEFT, M, D);

  //Font.Height := MulDiv(Font.Height, M, D);   //  Not neccesary
  IconFont.Height := MulDiv(IconFont.Height, M, D);
end;

procedure TUCustomRadioButton.Paint;
var
  TextH: Integer;
  IconH: Integer;
begin
  inherited;

  Canvas.Brush.Style := bsSolid;
  Canvas.Brush.Color := Color;  //  Paint empty background
  Canvas.FillRect(TRect.Create(0, 0, Width, Height));
  Canvas.Brush.Style := bsClear;

  //  Paint text
  Canvas.Font := Self.Font;
  if ThemeManager = nil then
    Canvas.Font.Color := $000000
  else if ThemeManager.Theme = utLight then
    Canvas.Font.Color := $000000
  else
    Canvas.Font.Color := $FFFFFF;

  TextH := Canvas.TextHeight(Text);
  Canvas.TextOut(TEXT_LEFT, (Height - TextH) div 2, Text);

  //  Paint radio
  Canvas.Font := IconFont;
  if IsChecked = false then
    begin
      //  Paint circle border (black in light, white in dark)
      if ThemeManager = nil then
        Canvas.Font.Color := $000000
      else if ThemeManager.Theme = utLight then
        Canvas.Font.Color := $000000
      else
        Canvas.Font.Color := $FFFFFF;

      IconH := Canvas.TextHeight('');
      Canvas.TextOut(ICON_LEFT, (Height - IconH) div 2, '');
    end
  else
    begin
      //  Paint circle border (active color)
      if ThemeManager = nil then
        Canvas.Font.Color := CustomActiveColor
      else
        Canvas.Font.Color := ThemeManager.ActiveColor;

      IconH := Canvas.TextHeight('');
      Canvas.TextOut(ICON_LEFT, (Height - IconH) div 2, '');

      //  Paint small circle inside (black in light, white in dark)
      if ThemeManager = nil then
        Canvas.Font.Color := $000000
      else if ThemeManager.Theme = utLight then
        Canvas.Font.Color := $000000
      else 
        Canvas.Font.Color := $FFFFFF;

      IconH := Canvas.TextHeight('');
      Canvas.TextOut(ICON_LEFT, (Height - IconH) div 2, '');
    end;
end;

{ MESSAGES }

procedure TUCustomRadioButton.WMLButtonUp(var Msg: TMessage);
var 
  i: Integer;
begin
  //  Only unchecked can change
  if (Enabled = true) and (HitTest = true) then
    begin
      if IsChecked = false then
        begin
          IsChecked := true;  //  Check it

          //  Uncheck other TUCustomRadioButton with the same parent and group name
          for i := 0 to Parent.ControlCount - 1 do
            if Parent.Controls[i] is TUCustomRadioButton then
              if
                ((Parent.Controls[i] as TUCustomRadioButton).Group = Group)
                and (Parent.Controls[i] <> Self)
              then
                (Parent.Controls[i] as TUCustomRadioButton).IsChecked := false;
        end;

      inherited;
    end;
end;

end.
