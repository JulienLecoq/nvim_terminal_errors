# nvim\_terminal\_errors

A plugin for Neovim allowing to jump to files that contain errors according to the terminal.

# Installation

This plugin has been tested with Neovim v0.9.0-dev-71-gd9a80b8e2.

Using packer:

```lua
return require("packer").startup(function(use)
    use {
        "JulienLecoq/nvim_terminal_errors",
        requires = {
            { "wsdjeg/vim-fetch" },
            { "nvim-telescope/telescope.nvim" },
            { "nvim-lua/plenary.nvim" }
        }
    }
end)
```

# Supported project types 

The list of projects that are supported by this plugin.

| project types | Go to next error file | Go to previous error file | List errors |
|:-------------:|:---------------------:|:-------------------------:|:-----------:|
|    angular    |          Yes          |            Yes            |     Yes     |

# Commands

The following commands are exposed:
- GoToPreviousErrorFileFromTerminal 
- GoToNextErrorFileFromTerminal 
- ListErrorsFromTerminal

You can easily maps them to keys in your .vim or .lua configuration code.

# Example configuration

In a lua file:

```lua 
local nvim_terminal_errors = require('nvim_terminal_errors')

nvim_terminal_errors.setup()

local options = {
    noremap = true,
    silent = true
}

vim.api.nvim_set_keymap("n", "<leader>ep", '<cmd>GoToPreviousErrorFileFromTerminal<cr>', options)
vim.api.nvim_set_keymap("n", "<leader>en", '<cmd>GoToNextErrorFileFromTerminal<cr>', options)
vim.api.nvim_set_keymap("n", "<leader>ef", '<cmd>ListErrorsFromTerminal<cr>', options)
```
