# nvim\_terminal\_errors

A plugin for Neovim allowing to jump to files that contain errors according to a terminal.

# Installation

This plugin has been tested with Neovim v0.9.0-dev-71-gd9a80b8e2.

Using packer:

```lua
return require("packer").startup(function(use)
    use {
        "JulienLecoq/nvim_terminal_errors",
        requires = {
            { "wsdjeg/vim-fetch" },
        }
    }
end)
```

# Supported project types 

The list of projects that ha

| project types | remove modifiers | remove semi-colons | remove for parenthesis | remove if parenthesis | remove types |
|:-------------:|:----------------:|:------------------:|:----------------------:|:---------------------:|:------------:|
|       ts      |        Yes       |         Yes        |           Yes          |          Yes          |      Yes     |
|      cpp      |        No        |         Yes        |           Yes          |          Yes          |      Yes     |

# Commands

The following commands are exposed:
- GoToPreviousErrorFile
- GoToNextErrorFile

You can easily maps them to keys in your .vim or .lua configuration code.

# Example configuration
