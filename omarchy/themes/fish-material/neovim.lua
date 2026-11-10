return {
  {
    "bjarneo/aether.nvim",
    branch = "v3",
    name = "aether",
    priority = 1000,
    opts = {
      colors = {
        bg         = "#090e14",
        dark_bg    = "#070b0f",
        darker_bg  = "#05070a",
        lighter_bg = "#22262c",

        fg         = "#f0ffff",
        dark_fg    = "#b4bfbf",
        light_fg   = "#f2ffff",
        bright_fg  = "#f4ffff",
        muted      = "#5f606c",

        red        = "#c46b71",
        yellow     = "#ffb0b5",
        orange     = "#cd8186",
        green      = "#47a6c4",
        cyan       = "#5ab7d5",
        blue       = "#7694b7",
        purple     = "#5e5f6b",
        brown      = "#7b4d50",

        bright_red    = "#c96f75",
        bright_yellow = "#ffbfc3",
        bright_green  = "#57b4d2",
        bright_cyan   = "#64c0df",
        bright_blue   = "#84a2c5",
        bright_purple = "#70717e",

        accent               = "#d2787d",
        cursor               = "#f2ffff",
        foreground           = "#f2ffff",
        background           = "#0a0a0d",
        selection             = "#22262c",
        selection_foreground = "#f2ffff",
        selection_background = "#22262c",
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "aether",
    },
  },
}
