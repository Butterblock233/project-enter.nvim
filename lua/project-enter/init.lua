---@class project_enter
local M = {}

---@class project_enter.Config
---@field root_markers table<string, "file"|"directory">
local config = {
	root_markers = {
		['.git'] = 'directory',
		['init.lua'] = 'file',
	},
}

-- Cache to store project roots that have already been processed.
---@type table<string, boolean>
local cache = {}

--- Prints a debug message if vim.env.DEBUG is "true".
-- @param ... any Varargs to be printed.
local function debug(...)
	if vim.env.DEBUG == 'true' then
		local parts = { '[project-enter.nvim]' }
		for i = 1, select('#', ...) do
			parts[#parts + 1] = tostring((select(i, ...)))
		end
		print(table.concat(parts, ' '))
	end
end

--- Merges user-provided configuration with the default config.
-- @param user_config table The user's configuration table.
function M.setup(user_config)
	user_config = user_config or {}
	config = vim.tbl_deep_extend('force', config, user_config)
	debug('Setup complete. Root markers:', vim.inspect(config.root_markers))
end

--- Finds the project root directory based on configured markers.
-- @return string|nil The absolute path to the project root, or nil if not found.
local function get_project_root()
	local cwd = vim.fn.getcwd()
	debug('Finding project root from:', cwd)

	local markers_to_find = {}
	for marker, _ in pairs(config.root_markers) do
		table.insert(markers_to_find, marker)
	end

	if #markers_to_find == 0 then
		debug('No root markers configured.')
		return cwd
	end

	local found_markers = vim.fs.find(markers_to_find, { upward = true, path = cwd })

	for _, marker_path in ipairs(found_markers) do
		local marker_name = vim.fn.fnamemodify(marker_path, ':t')
		local marker_type = vim.uv.fs_stat(marker_path)
		if marker_type and config.root_markers[marker_name] == marker_type.type then
			local root = vim.fn.fnamemodify(marker_path, ':h')
			debug(
				'Found root marker:',
				marker_path,
				'type:',
				marker_type.type,
				'-> Project root:',
				root
			)
			return root
		end
	end

	debug('No project root found. Using current directory.')
	return cwd
end

--- Triggers the ProjectEnter event detection.
function M.trigger()
	local root = get_project_root()

	if not root or cache[root] then
		if cache[root] then
			debug('Skipping already processed root:', root)
		end
		return
	end
	debug('Processing project root:', root)

	local events = vim.api.nvim_get_autocmds({ event = 'User' })
	---@type {file: string, original: string}[]
	local patterns_to_check = {}

	for _, event in ipairs(events) do
		if
			event.pattern
			and type(event.pattern) == 'string'
			and event.pattern:find('^ProjectEnter ')
		then
			local file_pattern = event.pattern:gsub('^ProjectEnter ', '')
			if file_pattern ~= '' and file_pattern ~= '*' then
				debug('Found registered pattern:', event.pattern)
				table.insert(patterns_to_check, { file = file_pattern, original = event.pattern })
			end
		end
	end

	if #patterns_to_check == 0 then
		debug('No "ProjectEnter" patterns registered. Caching root.')
		cache[root] = true
		return
	end

	local triggered_any = false
	for _, p in ipairs(patterns_to_check) do
		local file_path = root .. '/' .. p.file
		debug('Checking for pattern file:', file_path)
		if vim.uv.fs_stat(file_path) then
			debug('Found file, triggering event for pattern:', p.original)
			vim.api.nvim_exec_autocmds('User', { pattern = p.original, modeline = false })
			triggered_any = true
		end
	end

	if triggered_any then
		debug('At least one event triggered. Caching root:', root)
		cache[root] = true
	end
end

--- Basic Test(Still WIP)
-- @return boolean Always returns true.
function M.example()
	return true
end

return M
