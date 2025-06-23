# project-enter.nvim

A lightweight Neovim plugin that detects when you enter a project and triggers a custom `User` event. Its primary use case is to conditionally load other plugins with `lazy.nvim` based on the project type.

## ✨ Features

- Automatically detects project root based on configurable markers (e.g., `.git`, `init.lua`).
- Triggers a `User ProjectEnter <filename>` event when a specific file is found in the project root.
- Zero-config required for basic usage.
- Debug mode for easy troubleshooting.

## 📦 Installation

Install with your favorite plugin manager.

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "Butterblock233/project-enter.nvim",
  -- No configuration needed for basic usage
}
```

## 🚀 Usage

The main way to use this plugin is with the `event` trigger in `lazy.nvim`. The event format is `"User ProjectEnter <filename>"`.

**Example**: Conditionally load `rust-tools.nvim` only in Rust projects.

```lua
{
  "simrat39/rust-tools.nvim",
  event = "User ProjectEnter cargo.toml",
  -- other config...
}
```

**Example**: Load `uv.nvim` in Python projects.


```lua
{
	"benomahony/uv.nvim",
	cond = true,
	event = "User ProjectEnter pyproject.toml",
	-- opts = {},
},

```

When you open a file inside a project containing `cargo.toml` or `package.json` in its root, the corresponding `User ProjectEnter` event will be fired, and `lazy.nvim` will load the plugin.

## ⚙️ Configuration
> [!Caution]
> This Part is still WIP. Normally, this puglin does not need extra configurations

You can configure the plugin by calling the `setup()` function.

**Default configuration**:

```lua
require("project-enter").setup({
  root_markers = {
    ['.git'] = 'directory',
    ['init.lua'] = 'file',
  },
})
```

### `root_markers`

A table that defines what files or directories mark a project root.
- The key is the name of the file or directory (e.g., `'.git'`).
- The value is the type, either `'file'` or `'directory'`.

**Example**: Add `.project` file and `_darcs` directory as root markers.

```lua
require("project-enter").setup({
  root_markers = {
    ['.git'] = 'directory',
    ['init.lua'] = 'file',
    ['.project'] = 'file',
    ['_darcs'] = 'directory',
  },
})
```

## 🐛 Debugging

To enable debug messages, set the `DEBUG`(or `vim.env.DEBUG`) environment variable to `"true"` before starting Neovim.

```sh
DEBUG=true nvim
```

The plugin will then print detailed information about its execution, such as the detected project root and the events being triggered.
