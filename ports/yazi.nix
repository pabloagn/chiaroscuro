{ lib }:

{ colors, variant ? "zen" }:
let
  palette = colors.${variant} or colors.zen;
  
  bg = palette.sumiInk1 or "#1F1F28";
  
  tomlContent = ''
    [manager]
    marker_copied = { fg = "${palette.springGreen or "#98BB6C"}", bg = "${palette.springGreen or "#98BB6C"}" }
    marker_cut = { fg = "${palette.samuraiRed or "#E82424"}", bg = "${palette.samuraiRed or "#E82424"}" }
    marker_marked = { fg = "${palette.springViolet1 or "#938AA9"}", bg = "${palette.springViolet1 or "#938AA9"}" }
    marker_selected = { fg = "${palette.surimiOrange or "#FFA066"}", bg = "${palette.surimiOrange or "#FFA066"}" }
    cwd = { fg = "${palette.carpYellow or "#E6C384"}" }
    hovered = { reversed = true }
    preview_hovered = { reversed = true }
    find_keyword = { fg = "${palette.surimiOrange or "#FFA066"}", bg = "${bg}" }
    find_position = {}
    tab_active = { reversed = true }
    tab_inactive = {}
    tab_width = 1
    count_copied = { fg = "${bg}", bg = "${palette.springGreen or "#98BB6C"}" }
    count_cut = { fg = "${bg}", bg = "${palette.samuraiRed or "#E82424"}" }
    count_selected = { fg = "${bg}", bg = "${palette.carpYellow or "#E6C384"}" }
    border_symbol = "│"
    border_style = { fg = "${palette.fujiWhite or "#DCD7BA"}" }
    
    [mode]
    normal_main = { fg = "${bg}", bg = "${palette.crystalBlue or "#7E9CD8"}" }
    normal_alt = { fg = "${palette.crystalBlue or "#7E9CD8"}", bg = "${bg}" }
    select_main = { fg = "${bg}", bg = "${palette.oniViolet or "#957FB8"}" }
    select_alt = { fg = "${palette.oniViolet or "#957FB8"}", bg = "${bg}" }
    unset_main = { fg = "${bg}", bg = "${palette.carpYellow or "#E6C384"}" }
    unset_alt = { fg = "${palette.carpYellow or "#E6C384"}", bg = "${bg}" }
    
    [status]
    sep_left = { open = "", close = "" }
    sep_right = { open = "", close = "" }
    overall = { fg = "${palette.fujiWhite or "#DCD7BA"}", bg = "${bg}" }
    progress_label = { fg = "${palette.crystalBlue or "#7E9CD8"}", bg = "${bg}", bold = true }
    progress_normal = { fg = "${bg}", bg = "${bg}" }
    progress_error = { fg = "${bg}", bg = "${bg}" }
    perm_type = { fg = "${palette.springGreen or "#98BB6C"}" }
    perm_read = { fg = "${palette.carpYellow or "#E6C384"}" }
    perm_write = { fg = "${palette.samuraiRed or "#E82424"}" }
    perm_exec = { fg = "${palette.waveAqua2 or "#7AA89F"}" }
    perm_sep = { fg = "${palette.springViolet1 or "#938AA9"}" }
    
    [pick]
    border = { fg = "${palette.springBlue or "#7FB4CA"}" }
    active = { fg = "${palette.springViolet1 or "#938AA9"}", bold = true }
    inactive = {}
    
    [input]
    border = { fg = "${palette.springBlue or "#7FB4CA"}" }
    title = {}
    value = {}
    selected = { reversed = true }
    
    [completion]
    border = { fg = "${palette.springBlue or "#7FB4CA"}" }
    active = { reversed = true }
    inactive = {}
    
    [tasks]
    border = { fg = "${palette.springBlue or "#7FB4CA"}" }
    title = {}
    hovered = { fg = "${palette.springViolet1 or "#938AA9"}" }
    
    [which]
    cols = 2
    separator = " - "
    separator_style = { fg = "${palette.fujiGray or "#727169"}" }
    mask = { bg = "${bg}" }
    rest = { fg = "${palette.fujiGray or "#727169"}" }
    cand = { fg = "${palette.waveAqua1 or "#6A9589"}" }
    desc = { fg = "${palette.fujiWhite or "#DCD7BA"}" }
    
    [help]
    on = { fg = "${palette.waveAqua2 or "#7AA89F"}" }
    run = { fg = "${palette.springViolet1 or "#938AA9"}" }
    desc = {}
    hovered = { reversed = true, bold = true }
    footer = { fg = "${bg}", bg = "${palette.fujiWhite or "#DCD7BA"}" }
    
    [notify]
    title_info = { fg = "${palette.springGreen or "#98BB6C"}" }
    title_warn = { fg = "${palette.carpYellow or "#E6C384"}" }
    title_error = { fg = "${palette.samuraiRed or "#E82424"}" }
    
    [filetype]
    rules = [
        # images
        { mime = "image/*", fg = "${palette.carpYellow or "#E6C384"}" },
        # media
        { mime = "{audio,video}/*", fg = "${palette.springViolet1 or "#938AA9"}" },
        # archives
        { mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}", fg = "${palette.samuraiRed or "#E82424"}" },
        # documents
        { mime = "application/{pdf,doc,rtf,vnd.*}", fg = "${palette.oniViolet or "#957FB8"}" },
        # broken links
        { name = "*", is = "orphan", fg = "${palette.samuraiRed or "#E82424"}" },
        # executables
        { name = "*", is = "exec", fg = "${palette.waveAqua2 or "#7AA89F"}" },
        # fallback
        { name = "*", fg = "${palette.fujiWhite or "#DCD7BA"}" },
        { name = "*/", fg = "${palette.crystalBlue or "#7E9CD8"}" },
    ]
  '';
  
in {
  config = tomlContent;
}
