unit RegisterPackage;

interface

uses
  System.Classes;

procedure Register;

implementation

uses
  UCL.IntAnimation,
  UCL.TUThemeManager,
  UCL.TUForm, UCL.TUCaptionBar,
  UCL.TUSymbolButton, UCL.TUButton, UCL.TUText, UCL.TUHyperLink, UCL.TUPanel,
  UCL.TUCheckBox, UCL.TUProgressBar, UCL.TUSwitch, UCL.TUScrollBox, UCL.TURadioButton,
  UCL.TUPopupBox, UCL.TUPopupMenu, UCL.TUItemButton, UCL.TUSeparator, UCL.TUEdit
  ;

procedure Register;
begin
  RegisterComponents('Universal CL', [
    TUThemeManager,
    //TUForm,
    TUCaptionBar, TUSymbolButton, TUButton, TUText, TUHyperLink, TUPanel, TUCheckBox, TUProgressBar,
    TUSwitch, TUScrollBox, TURadioButton, TUPopupBox, TUPopupMenu, TUItemButton, TUSeparator, TUEdit
    ]);
end;

end.
