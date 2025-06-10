{ lib }:

{ colors, variant ? "zen" }:
let
  palette = colors.${variant} or colors.zen;
  bg = palette.sumiInk1;
in
{
  normal = {
    a = { bg = palette.crystalBlue; fg = bg; };
    b = { bg = "NONE"; fg = palette.crystalBlue; };
    c = { bg = "NONE"; fg = palette.fujiWhite; };
  };
  
  insert = {
    a = { bg = palette.springGreen; fg = bg; };
    b = { bg = "NONE"; fg = palette.springGreen; };
  };
  
  command = {
    a = { bg = palette.boatYellow2; fg = bg; };
    b = { bg = "NONE"; fg = palette.boatYellow2; };
  };
  
  visual = {
    a = { bg = palette.oniViolet; fg = bg; };
    b = { bg = "NONE"; fg = palette.oniViolet; };
  };
  
  replace = {
    a = { bg = palette.autumnRed; fg = bg; };
    b = { bg = "NONE"; fg = palette.autumnRed; };
  };
  
  inactive = {
    a = { bg = "NONE"; fg = palette.sumiInk6; };
    b = { bg = "NONE"; fg = palette.sumiInk6; };
    c = { bg = "NONE"; fg = palette.sumiInk6; };
  };
}
