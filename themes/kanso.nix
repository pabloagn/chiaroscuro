{ lib, src }:

let
  colorsLua = builtins.readFile "${src}/lua/kanso/colors.lua";
  
  extractColors = lua:
    let
      lines = lib.splitString "\n" lua;
      
      colorPattern = ''^[[:space:]]*([a-zA-Z0-9_]+)[[:space:]]*=[[:space:]]*"(#[0-9A-Fa-f]{6})"'';
      
      parseLine = line:
        let
          cleaned = builtins.head (lib.splitString "--" line);
          trimmed = lib.strings.trim cleaned;
          
          match = builtins.match colorPattern trimmed;
        in
          if match != null then
            { ${builtins.elemAt match 0} = builtins.elemAt match 1; }
          else
            {};
      
      allColors = lib.fold (a: b: a // b) {} (map parseLine lines);
    in
      allColors;
  
  palette = extractColors colorsLua;
  
in {
  inherit palette;
  
  zen = palette;
  ink = palette;
  pearl = palette // {
  };
}
