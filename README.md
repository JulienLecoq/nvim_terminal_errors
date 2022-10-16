# nvim\_terminal\_errors

A plugin for Neovim allowing to jump to files that contain errors according to a terminal buffer.

## Table of Contents
1. [Installation](#installation)
2. [Example configuration](#example-configuration)
3. [Supported project types](#supported-project-types)
4. [Commands](#commands)

# Installation

This plugin has been tested with Neovim v0.9.0-dev-71-gd9a80b8e2.

Using [packer](https://github.com/wbthomason/packer.nvim):

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

# Configuration example 

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

# Supported project types 

The list of projects that are supported by this plugin:

|   project types    | Go to next error file | Go to previous error file | List errors |
|:------------------:|:---------------------:|:-------------------------:|:-----------:|
| Ionic with Angular |          Yes          |            Yes            |     Yes     |

# Commands

The following commands are exposed:
- GoToNextErrorFileFromTerminal 
- GoToPreviousErrorFileFromTerminal 
- ListErrorsFromTerminal

You can easily maps them to keys in your .vim or .lua configuration code.

### True for all commands

The errors taken into account by the plugin are only the errors from the last build of the terminal.

### GoToNextErrorFileFromTerminal 

#### Inside a terminal

Calling this command makes you jump to the next error file according to your cursor position and the errors reported by the terminal.

If your cursor position is at the end of the terminal, it jumps to the first error reported by the terminal.

#### Outside a terminal

Calling this command makes you jump to the first error file according to the errors reported by the first terminal that you opened. 

### GoToPreviousErrorFileFromTerminal 

#### Inside a terminal

Calling this command makes you jump to the previous error file according to your cursor position and the errors reported by the terminal.

If your cursor position is at the beginning of the terminal, it jumps to the last error reported by the terminal.

#### Outside a terminal

Calling this command makes you jump to the last error file according to the errors reported by the first terminal that you opened.

### ListErrorsFromTerminal

#### Inside a terminal

Calling this command open a list via [Telescope](https://github.com/nvim-telescope/telescope.nvim) of all the errors reported by the terminal. Clicking on an error opens the error file corresponding to that error.

#### Outside a terminal

Calling this command open a list via [Telescope](https://github.com/nvim-telescope/telescope.nvim) of all the errors reported by the first terminal that you opened. Clicking on an error opens the error file corresponding to that error.
