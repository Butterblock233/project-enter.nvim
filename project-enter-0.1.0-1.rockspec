package = "project-enter"
version = "0.1.0-1"
source = {
   url = "git://github.com/butter/project-enter.nvim.git",
   tag = "v0.1.0"
}
description = {
   summary = "A Neovim plugin for project entry management.",
   detailed = [[
      project-enter.nvim is a plugin for Neovim that helps manage project entry points.
      It provides functionality to quickly navigate and enter project directories.
   ]],
   homepage = "https://github.com/butter/project-enter.nvim",
   license = "MIT"
}
dependencies = {
   "lua >= 5.1"
}
build = {
   type = "builtin",
   modules = {
      ["project-enter.init"] = "lua/project-enter/init.lua"
   }
}
