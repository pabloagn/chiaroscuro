{ lib }:

{ colors, variant ? "zen" }:
let
  palette = colors.${variant} or colors.zen;
  bg = palette.zen0;
in
{
  theme = {
    manager = {
      marker_copied = { fg = palette.springGreen; bg = palette.springGreen; };
      marker_cut = { fg = palette.zenRed; bg = palette.zenRed; };
      marker_marked = { fg = palette.springViolet1; bg = palette.springViolet1; };
      marker_selected = { fg = palette.roninYellow; bg = palette.roninYellow; };
      cwd = { fg = palette.carpYellow; };
      hovered = { reversed = true; };
      preview_hovered = { reversed = true; };
      find_keyword = { fg = palette.roninYellow; bg = bg; };
      find_position = {};
      tab_active = { reversed = true; };
      tab_inactive = {};
      tab_width = 1;
      count_copied = { fg = bg; bg = palette.springGreen; };
      count_cut = { fg = bg; bg = palette.zenRed; };
      count_selected = { fg = bg; bg = palette.carpYellow; };
      border_symbol = "│";
      border_style = { fg = palette.oldWhite; };
    };
    
    mode = {
      normal_main = { fg = bg; bg = palette.springBlue; };
      normal_alt = { fg = palette.springBlue; bg = bg; };
      select_main = { fg = bg; bg = palette.springViolet1; };
      select_alt = { fg = palette.springViolet1; bg = bg; };
      unset_main = { fg = bg; bg = palette.carpYellow; };
      unset_alt = { fg = palette.carpYellow; bg = bg; };
    };
    
    status = {
      sep_left = { open = ""; close = ""; };
      sep_right = { open = ""; close = ""; };
      overall = { fg = palette.oldWhite; bg = bg; };
      progress_label = { fg = palette.springBlue; bg = bg; bold = true; };
      progress_normal = { fg = bg; bg = bg; };
      progress_error = { fg = bg; bg = bg; };
      perm_type = { fg = palette.springGreen; };
      perm_read = { fg = palette.carpYellow; };
      perm_write = { fg = palette.zenRed; };
      perm_exec = { fg = palette.zenAqua2; };
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
      separator_style = { fg = palette.katanaGray; };
      mask = { bg = bg; };
      rest = { fg = palette.katanaGray; };
      cand = { fg = palette.zenAqua1; };
      desc = { fg = palette.oldWhite; };
    };
    
    help = {
      on = { fg = palette.zenAqua2; };
      run = { fg = palette.springViolet1; };
      desc = {};
      hovered = { reversed = true; bold = true; };
      footer = { fg = bg; bg = palette.oldWhite; };
    };
    
    notify = {
      title_info = { fg = palette.springGreen; };
      title_warn = { fg = palette.carpYellow; };
      title_error = { fg = palette.zenRed; };
    };
    
    filetype = {
      rules = [
        { mime = "image/*"; fg = palette.carpYellow; }
        { mime = "{audio,video}/*"; fg = palette.springViolet1; }
        { mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}"; fg = palette.zenRed; }
        { mime = "application/{pdf,doc,rtf,vnd.*}"; fg = palette.springViolet1; }
        { name = "*"; is = "orphan"; fg = palette.zenRed; }
        { name = "*"; is = "exec"; fg = palette.zenAqua2; }
        { name = "*"; fg = palette.oldWhite; }
        { name = "*/"; fg = palette.springBlue; }
      ];
    };
  };
}
