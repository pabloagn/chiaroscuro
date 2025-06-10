{ lib }:

{ colors, variant ? "zen" }:
let
  palette = colors.${variant} or colors.zen;
in
{
  background = palette.zen0;
  foreground = palette.oldWhite;
  
  selection_background = palette.zenBlue2;
  selection_foreground = palette.oldWhite;
  
  cursor = palette.oldWhite;
  cursor_text_color = palette.zen0;
  
  url_color = palette.springBlue;
  
  active_tab_background = palette.zen0;
  active_tab_foreground = palette.oldWhite;
  inactive_tab_background = palette.zen0;
  inactive_tab_foreground = palette.katanaGray;
  
  color0 = palette.zen0;
  color1 = palette.autumnRed;
  color2 = palette.autumnGreen;
  color3 = palette.autumnYellow;
  color4 = palette.springBlue;
  color5 = palette.springViolet1;
  color6 = palette.zenAqua1;
  color7 = palette.oldWhite;
  
  color8 = palette.katanaGray;
  color9 = palette.zenRed;
  color10 = palette.springGreen;
  color11 = palette.carpYellow;
  color12 = palette.springBlue;
  color13 = palette.springViolet1;
  color14 = palette.zenAqua2;
  color15 = palette.fujiWhite;
  
  color16 = palette.roninYellow;
  color17 = palette.samuraiRed;
}
