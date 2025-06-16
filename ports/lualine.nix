{ lib }:

{ colors, variant ? "zen" }:
let
  palette = colors.${variant} or colors.zen;
  bg = palette.zen0;
in
{
  normal = {
    a = { bg = palette.springBlue; fg = bg; };
    b = { bg = "NONE"; fg = palette.springBlue; };
    c = { bg = "NONE"; fg = palette.oldWhite; };
  };
  
  insert = {
    a = { bg = palette.springGreen; fg = bg; };
    b = { bg = "NONE"; fg = palette.springGreen; };
  };
  
  command = {
    a = { bg = palette.autumnYellow; fg = bg; };
    b = { bg = "NONE"; fg = palette.autumnYellow; };
  };
  
  visual = {
    a = { bg = palette.springViolet1; fg = bg; };
    b = { bg = "NONE"; fg = palette.springViolet1; };
  };
  
  replace = {
    a = { bg = palette.autumnRed; fg = bg; };
    b = { bg = "NONE"; fg = palette.autumnRed; };
  };
  
  inactive = {
    a = { bg = "NONE"; fg = palette.katanaGray; };
    b = { bg = "NONE"; fg = palette.katanaGray; };
    c = { bg = "NONE"; fg = palette.katanaGray; };
  };
}
