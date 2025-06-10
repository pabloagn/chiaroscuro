{ lib }:

{ colors, variant ? "zen" }:
let
  palette = colors.${variant} or colors.zen;
in
{
  palette = [
    palette.sumiInk0
    palette.autumnRed
    palette.autumnGreen
    palette.boatYellow2
    palette.crystalBlue
    palette.oniViolet
    palette.waveAqua1
    palette.fujiGray
    palette.sumiInk6
    palette.samuraiRed
    palette.springGreen
    palette.carpYellow
    palette.springBlue
    palette.springViolet1
    palette.waveAqua2
    palette.fujiWhite
  ];
  background = palette.sumiInk1;
  foreground = palette.fujiWhite;
  cursor-color = palette.fujiWhite;
  selection-background = palette.waveBlue2;
  selection-foreground = palette.fujiWhite;
}
