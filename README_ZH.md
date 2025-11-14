# project-enter.nvim

一个轻量级的 Neovim 插件，它能检测您何时进入一个项目，并触发一个自定义的 `User ProjectEnter <Pattern>` 事件。其主要用途是与 `lazy.nvim` 配合，根据项目类型来按需加载其他插件。


## ✨ 特性

- 根据可配置的标记（如 `.git`、`Makefile`）自动检测项目根目录。并触发 `User ProjectEnter <Pattern>` 事件。
- 基础用法无需任何配置。
- 提供调试模式，方便排查问题。

## 📦 安装

使用您喜欢的插件管理器进行安装。

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "Butterblock233/project-enter.nvim",
  -- 基础用法无需配置
}
```

## 🚀 用法

该插件主要与 `lazy.nvim` 的 `event` 触发器配合使用。事件格式为 `"User ProjectEnter <Pattern>"`。`<Pattern>` 可以是文件或目录。

**示例**：仅在 Git 存储库中加载 `gitsigns.nvim`。

```lua
{
  "lewis6991/gitsigns.nvim",
  event = "User ProjectEnter .git",
  -- other configs...
}
```

**示例**：在 Python 项目中加载 `uv.nvim`。

```lua
{
  "benomahony/uv.nvim",
  cond = true,
  event = "User ProjectEnter pyproject.toml",
  -- opts = {},
}
```

当您在项目根目录包含 `.git` 或 `pyproject.toml` 的项目中打开文件时，相应的 `User ProjectEnter` 事件将被触发，`lazy.nvim` 将加载对应的插件。

## 🐛 调试

要启用调试信息，请在启动 Neovim 之前将环境变量 `DEBUG` (或 `vim.env.DEBUG`) 设置为 `"true"`。

```sh
DEBUG=true nvim
```

插件将会打印出详细的执行信息，例如检测到的项目根目录和正在触发的事件。
