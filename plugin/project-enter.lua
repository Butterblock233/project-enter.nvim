-- It's good practice to wrap plugin setup in a pcall to avoid errors
-- from breaking user's init.lua.
local status_ok, project_enter = pcall(require, 'project-enter')
if not status_ok then
	return
end

-- Initialize the plugin with default settings.
-- Users can override this by calling setup() themselves in their config.
project_enter.setup()

-- Create a dedicated autocommand group for this plugin.
local group = vim.api.nvim_create_augroup('ProjectEnterTrigger', { clear = true })

-- Call the trigger function when Neovim starts or a new buffer is entered.
vim.api.nvim_create_autocmd({ 'VimEnter', 'BufEnter' }, {
	group = group,
	pattern = '*',
	callback = function()
		-- The trigger function is already wrapped in the main module.
		project_enter.trigger()
	end,
	desc = 'Trigger ProjectEnter event detection',
})
