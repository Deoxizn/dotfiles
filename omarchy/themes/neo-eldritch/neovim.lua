return {
  {
    "omacom-io/aether.nvim",
    branch = "v3",
    name = "aether",
    priority = 1000,
    opts = {
      colors = {
        bg         = "#1c2023",
        dark_bg    = "#15181a",
        darker_bg  = "#0e1012",
        lighter_bg = "#333639",

        fg         = "#c7ccd1",
        dark_fg    = "#95999d",
        light_fg   = "#cfd4d8",
        bright_fg  = "#d5d9dd",
        muted      = "#747c84",

        red        = "#cf867c",
        yellow     = "#aec795",
        orange     = "#d69890",
        green      = "#95c7ae",
        cyan       = "#73899f",
        blue       = "#6f8aad",
        purple     = "#aa5b82",
        brown      = "#805b56",

        bright_red    = "#cf867c",
        bright_yellow = "#aec795",
        bright_green  = "#95c7ae",
        bright_cyan   = "#73899f",
        bright_blue   = "#6f8aad",
        bright_purple = "#aa5b82",

        accent               = "#a881b7",
        cursor               = "#d8e1d4",
        foreground           = "#c7ccd1",
        background           = "#1c2023",
        selection             = "#333639",
        selection_foreground = "#c7ccd1",
        selection_background = "#333639",
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
