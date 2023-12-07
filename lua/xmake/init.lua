local M = {}

local function catalogue_detection()
	local files = require("plenary.scandir").scan_dir(
		require("xmake.config").config.work_dir,
		{ depth = 1, search_pattern = "xmake.lua" }
	)

	for _, _ in pairs(files) do
		return true
	end
	return false
end

function M.setup(user_config)
	require("xmake.config").init(user_config)

	local work_dir = require("xmake.config").config
	if type(work_dir) == "string" then
		vim.cmd("cd " .. work_dir)
	else
		vim.cmd("cd " .. table.concat(work_dir, ""))
	end

	if vim.system == nil then
		require("xmake.log").error(
			"Plugin to stop loading!!!! You are using a low version of neovim that does not have a `vim.system`. Please select the v1 branch plugin."
		)
		return
	end

	if not catalogue_detection() then
		return
	end

	require("xmake.project_config").init()
	require("xmake.execu").init()
	require("xmake.autocmd").init()
end

return M
