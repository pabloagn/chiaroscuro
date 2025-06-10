{ lib }:

{ colors, variant ? "zen" }:
let
  palette = colors.${variant} or colors.zen;
  
  kittyColors = {
    # Primary colors
    background = palette.sumiInk1 or "#1F1F28";
    foreground = palette.fujiWhite or "#DCD7BA";
    
    # Selection colors
    selection_background = palette.waveBlue2 or "#2D4F67";
    selection_foreground = palette.fujiWhite or "#DCD7BA";
    
    # Cursor colors
    cursor = palette.fujiWhite or "#DCD7BA";
    cursor_text_color = palette.sumiInk1 or "#1F1F28";
    
    # URL color
    url_color = palette.springBlue or "#7FB4CA";
    
    # Tab colors
    active_tab_background = palette.sumiInk1 or "#1F1F28";
    active_tab_foreground = palette.fujiWhite or "#DCD7BA";
    inactive_tab_background = palette.sumiInk1 or "#1F1F28";
    inactive_tab_foreground = palette.sumiInk6 or "#727169";
    
    # Terminal colors
    color0 = palette.sumiInk0 or "#16161D";  # black
    color1 = palette.autumnRed or "#C34043";  # red
    color2 = palette.autumnGreen or "#76946A";  # green
    color3 = palette.boatYellow2 or "#C0A36E";  # yellow
    color4 = palette.crystalBlue or "#7E9CD8";  # blue
    color5 = palette.oniViolet or "#957FB8";  # magenta
    color6 = palette.waveAqua1 or "#6A9589";  # cyan
    color7 = palette.oldWhite or "#C8C093";  # white
    
    # Bright colors
    color8 = palette.fujiGray or "#727169";  # bright black
    color9 = palette.samuraiRed or "#E82424";  # bright red
    color10 = palette.springGreen or "#98BB6C";  # bright green
    color11 = palette.carpYellow or "#E6C384";  # bright yellow
    color12 = palette.springBlue or "#7FB4CA";  # bright blue
    color13 = palette.springViolet1 or "#938AA9";  # bright magenta
    color14 = palette.waveAqua2 or "#7AA89F";  # bright cyan
    color15 = palette.fujiWhite or "#DCD7BA";  # bright white
    
    # Extended colors
    color16 = palette.surimiOrange or "#FFA066";
    color17 = palette.peachRed or "#FF5D62";
  };
  
  configContent = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (name: value: "${name} ${value}") kittyColors
  );
  
in {
  colors = kittyColors;
  config = configContent;
}
