# project-enter.nvim

A lightweight Neovim plugin which provides a simple event for `lazy.nvim` to load plugins based on files or folders in your project. For example, you can load `venv-selecter` plugin only `.venv` folder exists.

## ✨ Features

- Automatically detects project root based on configurable markers (e.g., `.git`, `init.lua`).
- Triggers a `User ProjectEnter <Pattern>` event when a specific file is found in the project root.
- Zero-config required for basic usage.
- Debug mode for easy troubleshooting.

## 📦 Installation

Install with your favorite plugin manager.

### [lazy.nvim](https://github.com/folke/lazy.nvim) (Recommend)

```lua
{
  "Butterblock233/project-enter.nvim",
  event = "VeryLazy" -- Make sure the plugin can load properly
  -- No configuration needed for basic usage
}
```

## 🚀 Usage

The main way to use this plugin is with the `event` trigger in `lazy.nvim`. The event format is `"User ProjectEnter <Pattern>"`. `<Pattern>` can be either a file or a directory.

**Example**: Conditionally load `git-signs.nvim` only in git repositories.

```lua
{
  "lewis6991/gitsigns.nvim",
  event = "User ProjectEnter .git",
  -- other configs...
}
```

**Example**: Load `uv.nvim` in Python projects.

```lua
{
  "benomahony/uv.nvim",
  cond = true,
  event = "User ProjectEnter pyproject.toml",
  -- opts = {},
}
```

When you open a file inside a project containing `.git` or `pyproject.toml` in its root, the corresponding `User ProjectEnter` event will be fired, and `lazy.nvim` will load the plugin.


## 🐛 Debugging

To enable debug messages, set the `DEBUG` (or `vim.env.DEBUG`) environment variable to `"true"` before starting Neovim.

```sh
DEBUG=true nvim
```

The plugin will then print detailed information about its execution, such as the detected project root and the events being triggered.
