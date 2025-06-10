# Kanso Theme Extractor
# Extracts colors from kanso.nvim and converts to standardized format
{ lib, kansoSrc }:

{ variant ? "zen", overrides ? {} }:
let
  # Read the Kanso color definitions
  # We'll parse the Lua files to extract color values
  # This is a simplified version - in practice you might need more sophisticated parsing
  
  # For now, we'll define the colors based on the Kanso theme
  # In a real implementation, you'd parse the Lua files
  kansoColors = {
    zen = {
      # Core palette
      zen0 = "#0d0c0c";
      zen1 = "#191724";
      zen2 = "#1F1F28";
      zen3 = "#2A2A37";
      zen4 = "#363646";
      zen5 = "#54546D";
      
      fujiWhite = "#DCD7BA";
      oldWhite = "#C8C093";
      
      # Semantic colors
      sumiInk0 = "#16161D";
      sumiInk1 = "#1F1F28";
      sumiInk2 = "#2A2A37";
      sumiInk3 = "#363646";
      sumiInk4 = "#54546D";
      sumiInk5 = "#727169";
      sumiInk6 = "#938AA9";
      
      # Accent colors
      oniViolet = "#957FB8";
      crystalBlue = "#7E9CD8";
      springViolet = "#938056";
      springBlue = "#7FB4CA";
      springGreen = "#98BB6C";
      boatYellow = "#E6C384";
      sakuraPink = "#D27E99";
      waveRed = "#E46876";
      peachRed = "#FF5D62";
      carpYellow = "#E6C384";
      surimiOrange = "#FFA066";
      katanaGray = "#717C7C";
      
      # Special colors
      winterGreen = "#2D4F67";
      winterYellow = "#49443C";
      winterRed = "#43242B";
      winterBlue = "#252535";
      autumnGreen = "#76946A";
      autumnRed = "#C34043";
      autumnYellow = "#DCA561";
    };
    
    ink = {
      # Ink variant adjustments (inherits most from zen)
    };
    
    pearl = {
      # Light theme colors
      lotus0 = "#f2ecbc";
      lotus1 = "#f4e6d8";
      lotus2 = "#f6f0e8";
      lotus3 = "#e7dba0";
      lotus4 = "#e4d794";
      inkBlack = "#0d0c0c";
      inkGray = "#374349";
    };
  };
  
  # Get base colors for the variant
  baseColors = kansoColors.${variant} or kansoColors.zen;
  
  # Map Kanso colors to a standardized theme format
  standardTheme = {
    name = "kanso-${variant}";
    variant = if variant == "pearl" then "light" else "dark";
    
    # Primary UI colors
    ui = {
      bg = {
        primary = baseColors.zen1 or baseColors.lotus2 or "#191724";
        secondary = baseColors.zen2 or baseColors.lotus1 or "#1F1F28";
        tertiary = baseColors.zen3 or baseColors.lotus0 or "#2A2A37";
      };
      
      fg = {
        primary = baseColors.fujiWhite or baseColors.inkBlack or "#DCD7BA";
        secondary = baseColors.oldWhite or baseColors.inkGray or "#C8C093";
        muted = baseColors.sumiInk6 or baseColors.inkGray or "#938AA9";
      };
      
      border = {
        primary = baseColors.sumiInk4 or baseColors.lotus3 or "#54546D";
        active = baseColors.crystalBlue or "#7E9CD8";
      };
      
      selection = baseColors.winterBlue or baseColors.lotus3 or "#252535";
    };
    
    # Semantic colors
    diagnostic = {
      error = baseColors.waveRed or "#E46876";
      warning = baseColors.boatYellow or "#E6C384";
      info = baseColors.crystalBlue or "#7E9CD8";
      hint = baseColors.springGreen or "#98BB6C";
    };
    
    # Syntax colors
    syntax = {
      keyword = baseColors.oniViolet or "#957FB8";
      function = baseColors.crystalBlue or "#7E9CD8";
      string = baseColors.springGreen or "#98BB6C";
      variable = baseColors.fujiWhite or baseColors.inkBlack or "#DCD7BA";
      constant = baseColors.surimiOrange or "#FFA066";
      parameter = baseColors.carpYellow or "#E6C384";
      operator = baseColors.boatYellow or "#E6C384";
      type = baseColors.springBlue or "#7FB4CA";
      comment = baseColors.sumiInk6 or baseColors.inkGray or "#938AA9";
      punctuation = baseColors.katanaGray or "#717C7C";
    };
    
    # Version control colors
    vcs = {
      added = baseColors.autumnGreen or "#76946A";
      modified = baseColors.autumnYellow or "#DCA561";
      removed = baseColors.autumnRed or "#C34043";
    };
    
    # Terminal colors
    terminal = {
      black = baseColors.sumiInk0 or baseColors.inkBlack or "#16161D";
      red = baseColors.waveRed or "#E46876";
      green = baseColors.springGreen or "#98BB6C";
      yellow = baseColors.boatYellow or "#E6C384";
      blue = baseColors.crystalBlue or "#7E9CD8";
      magenta = baseColors.oniViolet or "#957FB8";
      cyan = baseColors.springBlue or "#7FB4CA";
      white = baseColors.fujiWhite or baseColors.lotus0 or "#DCD7BA";
      
      brightBlack = baseColors.sumiInk4 or baseColors.inkGray or "#54546D";
      brightRed = baseColors.peachRed or "#FF5D62";
      brightGreen = baseColors.springGreen or "#98BB6C";
      brightYellow = baseColors.carpYellow or "#E6C384";
      brightBlue = baseColors.crystalBlue or "#7E9CD8";
      brightMagenta = baseColors.springViolet or "#938056";
      brightCyan = baseColors.springBlue or "#7FB4CA";
      brightWhite = baseColors.fujiWhite or baseColors.lotus0 or "#DCD7BA";
    };
    
    # Raw palette access
    palette = baseColors;
  };
  
in
  # Apply user overrides using lib.recursiveUpdate
  lib.recursiveUpdate standardTheme overrides

