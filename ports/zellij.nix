{ lib }:

{ colors, variant ? "zen" }:
let
  palette = colors.${variant} or colors.zen;
in
{
  bg = palette.sumiInk1;
  fg = palette.fujiWhite;
  red = palette.autumnRed;
  green = palette.autumnGreen;
  blue = palette.crystalBlue;
  yellow = palette.boatYellow2;
  magenta = palette.oniViolet;
  orange = palette.surimiOrange;
  cyan = palette.waveAqua1;
  black = palette.sumiInk1;
  white = palette.fujiWhite;
}
