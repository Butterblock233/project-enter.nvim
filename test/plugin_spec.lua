local example = require('project-enter').example

describe('neovim plugin', function()
	it('work as expect', function()
		local result = example()
		assert.is_true(result)
	end)
end)
