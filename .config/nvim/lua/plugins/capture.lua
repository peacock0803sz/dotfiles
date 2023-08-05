local function config()
	vim.keymap.set("c", "<C-c>", function()
		if vim.fn.getcmdtype() == ":" then
			local cmdline = vim.fn.getcmdline()
			vim.fn.histadd(":", cmdline)
			vim.schedule(function()
				vim.cmd("Capture " .. cmdline)
			end)
		end
		return "<C-c>"
	end, { expr = true })
end

local spec = { "tyru/capture.vim", config = config }
return spec
