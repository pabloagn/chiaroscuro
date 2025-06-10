{ lib }:

{ colors, variant ? "zen" }:
let
  palette = colors.${variant} or colors.zen;
in
{
  background = palette.sumiInk1;
  foreground = palette.fujiWhite;
  
  selection_background = palette.waveBlue2;
  selection_foreground = palette.fujiWhite;
  
  cursor = palette.fujiWhite;
  cursor_text_color = palette.sumiInk1;
  
  url_color = palette.springBlue;
  
  active_tab_background = palette.sumiInk1;
  active_tab_foreground = palette.fujiWhite;
  inactive_tab_background = palette.sumiInk1;
  inactive_tab_foreground = palette.sumiInk6;
  
  color0 = palette.sumiInk0;
  color1 = palette.autumnRed;
  color2 = palette.autumnGreen;
  color3 = palette.boatYellow2;
  color4 = palette.crystalBlue;
  color5 = palette.oniViolet;
  color6 = palette.waveAqua1;
  color7 = palette.oldWhite;
  
  color8 = palette.fujiGray;
  color9 = palette.samuraiRed;
  color10 = palette.springGreen;
  color11 = palette.carpYellow;
  color12 = palette.springBlue;
  color13 = palette.springViolet1;
  color14 = palette.waveAqua2;
  color15 = palette.fujiWhite;
  
  color16 = palette.surimiOrange;
  color17 = palette.peachRed;
}

