{ lib }:

{ colors, variant ? "zen" }:
let
  palette = colors.${variant} or colors.zen;
  bg = palette.sumiInk1;
in
{
  theme = {
    manager = {
      marker_copied = { fg = palette.springGreen; bg = palette.springGreen; };
      marker_cut = { fg = palette.samuraiRed; bg = palette.samuraiRed; };
      marker_marked = { fg = palette.springViolet1; bg = palette.springViolet1; };
      marker_selected = { fg = palette.surimiOrange; bg = palette.surimiOrange; };
      cwd = { fg = palette.carpYellow; };
      hovered = { reversed = true; };
      preview_hovered = { reversed = true; };
      find_keyword = { fg = palette.surimiOrange; bg = bg; };
      find_position = {};
      tab_active = { reversed = true; };
      tab_inactive = {};
      tab_width = 1;
      count_copied = { fg = bg; bg = palette.springGreen; };
      count_cut = { fg = bg; bg = palette.samuraiRed; };
      count_selected = { fg = bg; bg = palette.carpYellow; };
      border_symbol = "│";
      border_style = { fg = palette.fujiWhite; };
    };
    
    mode = {
      normal_main = { fg = bg; bg = palette.crystalBlue; };
      normal_alt = { fg = palette.crystalBlue; bg = bg; };
      select_main = { fg = bg; bg = palette.oniViolet; };
      select_alt = { fg = palette.oniViolet; bg = bg; };
      unset_main = { fg = bg; bg = palette.carpYellow; };
      unset_alt = { fg = palette.carpYellow; bg = bg; };
    };
    
    status = {
      sep_left = { open = ""; close = ""; };
      sep_right = { open = ""; close = ""; };
      overall = { fg = palette.fujiWhite; bg = bg; };
      progress_label = { fg = palette.crystalBlue; bg = bg; bold = true; };
      progress_normal = { fg = bg; bg = bg; };
      progress_error = { fg = bg; bg = bg; };
      perm_type = { fg = palette.springGreen; };
      perm_read = { fg = palette.carpYellow; };
      perm_write = { fg = palette.samuraiRed; };
      perm_exec = { fg = palette.waveAqua2; };
      perm_sep = { fg = palette.springViolet1; };
    };
    
    pick = {
      border = { fg = palette.springBlue; };
      active = { fg = palette.springViolet1; bold = true; };
      inactive = {};
    };
    
    input = {
      border = { fg = palette.springBlue; };
      title = {};
      value = {};
      selected = { reversed = true; };
    };
    
    completion = {
      border = { fg = palette.springBlue; };
      active = { reversed = true; };
      inactive = {};
    };
    
    tasks = {
      border = { fg = palette.springBlue; };
      title = {};
      hovered = { fg = palette.springViolet1; };
    };
    
    which = {
      cols = 2;
      separator = " - ";
      separator_style = { fg = palette.fujiGray; };
      mask = { bg = bg; };
      rest = { fg = palette.fujiGray; };
      cand = { fg = palette.waveAqua1; };
      desc = { fg = palette.fujiWhite; };
    };
    
    help = {
      on = { fg = palette.waveAqua2; };
      run = { fg = palette.springViolet1; };
      desc = {};
      hovered = { reversed = true; bold = true; };
      footer = { fg = bg; bg = palette.fujiWhite; };
    };
    
    notify = {
      title_info = { fg = palette.springGreen; };
      title_warn = { fg = palette.carpYellow; };
      title_error = { fg = palette.samuraiRed; };
    };
    
    filetype = {
      rules = [
        { mime = "image/*"; fg = palette.carpYellow; }
        { mime = "{audio,video}/*"; fg = palette.springViolet1; }
        { mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}"; fg = palette.samuraiRed; }
        { mime = "application/{pdf,doc,rtf,vnd.*}"; fg = palette.oniViolet; }
        { name = "*"; is = "orphan"; fg = palette.samuraiRed; }
        { name = "*"; is = "exec"; fg = palette.waveAqua2; }
        { name = "*"; fg = palette.fujiWhite; }
        { name = "*/"; fg = palette.crystalBlue; }
      ];
    };
  };
}
