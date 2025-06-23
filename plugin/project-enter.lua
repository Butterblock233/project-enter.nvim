-- Create a dedicated autocommand group for this plugin.
local group = vim.api.nvim_create_augroup('ProjectEnterTrigger', { clear = true })

-- Call the trigger function when Neovim starts or a new buffer is entered.
vim.api.nvim_create_autocmd({ 'VimEnter', 'BufEnter' }, {
  group = group,
  pattern = '*',
  callback = function()
    -- Use a pcall to prevent errors from crashing the startup process.
    pcall(require, 'project-enter')
  end,
  desc = 'Trigger ProjectEnter event detection',
})
