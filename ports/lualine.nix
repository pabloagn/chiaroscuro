{ lib }:

{ colors, variant ? "zen" }:
let
  palette = colors.${variant} or colors.zen;
  
  bg = palette.sumiInk1 or "#1F1F28";
  
  luaConfig = ''
    local kanso = {}
    
    kanso.normal = {
        a = { bg = "${palette.crystalBlue or "#7E9CD8"}", fg = "${bg}" },
        b = { bg = "NONE", fg = "${palette.crystalBlue or "#7E9CD8"}" },
        c = { bg = "NONE", fg = "${palette.fujiWhite or "#DCD7BA"}" },
    }
    
    kanso.insert = {
        a = { bg = "${palette.springGreen or "#98BB6C"}", fg = "${bg}" },
        b = { bg = "NONE", fg = "${palette.springGreen or "#98BB6C"}" },
    }
    
    kanso.command = {
        a = { bg = "${palette.boatYellow2 or "#C0A36E"}", fg = "${bg}" },
        b = { bg = "NONE", fg = "${palette.boatYellow2 or "#C0A36E"}" },
    }
    
    kanso.visual = {
        a = { bg = "${palette.oniViolet or "#957FB8"}", fg = "${bg}" },
        b = { bg = "NONE", fg = "${palette.oniViolet or "#957FB8"}" },
    }
    
    kanso.replace = {
        a = { bg = "${palette.autumnRed or "#C34043"}", fg = "${bg}" },
        b = { bg = "NONE", fg = "${palette.autumnRed or "#C34043"}" },
    }
    
    kanso.inactive = {
        a = { bg = "NONE", fg = "${palette.sumiInk6 or "#727169"}" },
        b = { bg = "NONE", fg = "${palette.sumiInk6 or "#727169"}" },
        c = { bg = "NONE", fg = "${palette.sumiInk6 or "#727169"}" },
    }
    
    if vim.g.kanso_lualine_bold then
        for _, mode in pairs(kanso) do
            mode.a.gui = "bold"
        end
    end
    
    return kanso
  '';
  
in {
  config = luaConfig;
}
