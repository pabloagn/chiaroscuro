{ lib }:

{ colors, variant ? "zen" }:
let
  palette = colors.${variant} or colors.zen;
  
  configContent = ''
    palette = 0=${palette.sumiInk0 or "#16161D"}
    palette = 1=${palette.autumnRed or "#C34043"}
    palette = 2=${palette.autumnGreen or "#76946A"}
    palette = 3=${palette.boatYellow2 or "#C0A36E"}
    palette = 4=${palette.crystalBlue or "#7E9CD8"}
    palette = 5=${palette.oniViolet or "#957FB8"}
    palette = 6=${palette.waveAqua1 or "#6A9589"}
    palette = 7=${palette.fujiGray or "#727169"}
    palette = 8=${palette.sumiInk6 or "#727169"}
    palette = 9=${palette.samuraiRed or "#E82424"}
    palette = 10=${palette.springGreen or "#98BB6C"}
    palette = 11=${palette.carpYellow or "#E6C384"}
    palette = 12=${palette.springBlue or "#7FB4CA"}
    palette = 13=${palette.springViolet1 or "#938AA9"}
    palette = 14=${palette.waveAqua2 or "#7AA89F"}
    palette = 15=${palette.fujiWhite or "#DCD7BA"}
    background = ${palette.sumiInk1 or "#1F1F28"}
    foreground = ${palette.fujiWhite or "#DCD7BA"}
    cursor-color = ${palette.fujiWhite or "#DCD7BA"}
    selection-background = ${palette.waveBlue2 or "#2D4F67"}
    selection-foreground = ${palette.fujiWhite or "#DCD7BA"}
  '';
  
in {
  config = configContent;
}

