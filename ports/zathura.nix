{ lib }:

{ colors, variant ? "zen" }:
let
  palette = colors.${variant} or colors.zen;
  bg = palette.sumiInk1;
in
{
  notification-error-bg = bg;
  notification-error-fg = palette.autumnRed;
  notification-warning-bg = bg;
  notification-warning-fg = palette.carpYellow;
  notification-bg = bg;
  notification-fg = palette.fujiWhite;
  completion-bg = bg;
  completion-fg = palette.fujiWhite;
  completion-group-bg = bg;
  completion-group-fg = palette.fujiWhite;
  completion-highlight-bg = palette.waveAqua2;
  completion-highlight-fg = bg;
  index-bg = bg;
  index-fg = palette.fujiGray;
  index-active-bg = palette.fujiGray;
  index-active-fg = bg;
  inputbar-bg = bg;
  inputbar-fg = palette.fujiWhite;
  statusbar-bg = bg;
  statusbar-fg = palette.fujiWhite;
  highlight-color = palette.carpYellow;
  highlight-active-color = palette.autumnRed;
  default-bg = bg;
  default-fg = palette.fujiWhite;
  render-loading = true;
  render-loading-bg = bg;
  render-loading-fg = palette.fujiWhite;
  recolor-lightcolor = bg;
  recolor-darkcolor = palette.fujiWhite;
  recolor = true;
}
