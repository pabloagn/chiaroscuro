{ lib }:

{ colors, variant ? "zen" }:
let
  palette = colors.${variant} or colors.zen;
in
{
  colors = {
    primary = {
      background = palette.sumiInk1 or "#1F1F28";
      foreground = palette.fujiWhite or "#DCD7BA";
    };
    
    cursor = {
      text = palette.sumiInk1 or "#1F1F28";
      cursor = palette.fujiWhite or "#DCD7BA";
    };
    
    selection = {
      background = palette.waveBlue2 or "#2D4F67";
      foreground = palette.fujiWhite or "#DCD7BA";
    };
    
    normal = {
      black = palette.sumiInk0 or "#16161D";
      red = palette.autumnRed or "#C34043";
      green = palette.autumnGreen or "#76946A";
      yellow = palette.boatYellow2 or "#C0A36E";
      blue = palette.crystalBlue or "#7E9CD8";
      magenta = palette.oniViolet or "#957FB8";
      cyan = palette.waveAqua1 or "#6A9589";
      white = palette.oldWhite or "#C8C093";
    };
    
    bright = {
      black = palette.fujiGray or "#727169";
      red = palette.samuraiRed or "#E82424";
      green = palette.springGreen or "#98BB6C";
      yellow = palette.carpYellow or "#E6C384";
      blue = palette.springBlue or "#7FB4CA";
      magenta = palette.springViolet1 or "#938AA9";
      cyan = palette.waveAqua2 or "#7AA89F";
      white = palette.fujiWhite or "#DCD7BA";
    };
    
    # Kitty-specific
    url_color = palette.springBlue or "#7FB4CA";
    
    tab_bar = {
      active = {
        background = palette.sumiInk1 or "#1F1F28";
        foreground = palette.fujiWhite or "#DCD7BA";
      };
      inactive = {
        background = palette.sumiInk1 or "#1F1F28";
        foreground = palette.sumiInk6 or "#727169";
      };
    };
  };
}
