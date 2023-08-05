local setup_keymaps = function()
	vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
	vim.keymap.set("n", "<space>[d", vim.diagnostic.goto_prev)
	vim.keymap.set("n", "<space>]d", vim.diagnostic.goto_next)
	vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("LspConfig", {}),
		callback = function(ev)
			local bufopts = { noremap = true, silent = true, buffer = ev.buf }
			-- diagnostics mappings
			vim.keymap.set("n", "<space>gD", vim.lsp.buf.declaration, bufopts)
			vim.keymap.set("n", "<space>gd", vim.lsp.buf.definition, bufopts)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
			vim.keymap.set("n", "<space>gi", vim.lsp.buf.implementation, bufopts)
			-- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
			vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
			vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
			vim.keymap.set("n", "<space>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, bufopts)
			vim.keymap.set("n", "<space>gt", vim.lsp.buf.type_definition, bufopts)
			vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
			vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
			vim.keymap.set("n", "<space>gr", vim.lsp.buf.references, bufopts)
			vim.keymap.set("n", "<space>fo", vim.lsp.buf.format, bufopts)

			vim.keymap.set("n", "<space>or", vim.lsp.buf.code_action, bufopts)
		end,
	})
end

local function config()
	require("mason").setup()
	local lspconfig = require("lspconfig")
	local capabilities = require("cmp_nvim_lsp").default_capabilities()
	setup_keymaps()
	require("mason-lspconfig").setup()
	require("mason-lspconfig").setup_handlers({
		function(name)
			lspconfig[name].setup({
				capabilities = capabilities,
			})
		end,
		denols = function()
			lspconfig.denols.setup({
				init_options = {
					enable = true,
					lint = true,
					unstable = true,
				},
			})
		end,
		lua_ls = function()
			lspconfig.lua_ls.setup({
				settings = {
					Lua = {
						hint = { enable = true },
						format = { enable = false },
						runtime = { version = "LuaJIT" },
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})
		end,
		grammarly = function()
			lspconfig.grammarly.setup({
				cmd = {
					os.getenv("HOME") .. "/.nvm/versions/node/v16.18.1/bin/grammarly-languageserver",
					"--stdio",
				},
				filetypes = { "markdown", "tex", "text", "gitcommit" },
				init_options = { clientId = os.getenv("GRAMMARLY_CLIENT_ID") },
				single_file_support = true,
			})
		end,
	})
end

local spec = {
	{
		"williamboman/mason-lspconfig.nvim",
		config = config,
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
	},
}
return spec
