-- Enable LSPs, configured lower in the file (https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md)
-- Formatting etc listed at https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
vim.lsp.enable({
    "ts_ls",
    "html",
    "lua_ls",
    "nixd",
    "cssls",
    "jsonls",
    "bashls",
    "yamlls",
    "eslint",
    "pyright",
    "rust_analyzer",
})
local null_ls = require("null-ls")
local sources = {
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.formatting.alejandra,
    null_ls.builtins.formatting.stylua.with({
        extra_args = { "--indent-type", "Spaces" },
    }),
    null_ls.builtins.formatting.shfmt.with({
        extra_args = { "-i", "4", "-ci" },
    }),
    null_ls.builtins.formatting.yamlfmt,
    null_ls.builtins.formatting.black,
    {
        name = "rustfmt",
        method = null_ls.methods.FORMATTING,
        filetypes = { "rust" },
        generator = null_ls.formatter({
            command = "rustfmt",
            to_stdin = true,
        }),
    },
}

-- show diagnostics
vim.diagnostic.config({
    severity_sort = true,
    update_in_insert = true,
    virtual_text = {
        current_line = false,
        severity = {
            min = 2,
            max = 1,
        },
    },
})

--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.config("jsonls", {
    capabilities = capabilities,
})
vim.lsp.config("html", {
    provideFormatter = false,
    capabilities = capabilities,
})
vim.lsp.config("cssls", {
    capabilities = capabilities,
})
vim.lsp.config("nixd", {
    settings = {
        formatting = {
            command = "alejandra",
        },
    },
})
vim.lsp.config("rust_analyzer", {
    capabilities = capabilities,
})
vim.lsp.config("lua_ls", {
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
                path ~= vim.fn.stdpath("config")
                and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
            then
                return
            end
        end

        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you"re using (most
                -- likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
                -- Tell the language server how to find Lua modules same way as Neovim
                -- (see `:h lua-module-load`)
                path = {
                    "lua/?.lua",
                    "lua/?/init.lua",
                },
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    -- Depending on the usage, you might want to add additional paths
                    -- here.
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library"
                },
                -- Or pull in all of "runtimepath".
                -- NOTE: this is a lot slower and will cause issues when working on
                -- your own configuration.
                -- See https://github.com/neovim/nvim-lspconfig/issues/3189
                -- library = {
                --   vim.api.nvim_get_runtime_file("", true),
                -- }
            },
        })
    end,
    settings = {
        Lua = {},
    },
})

-- Autocompletion with blink.cmp
require("blink.cmp").setup({
    keymap = {
        preset = "default",
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
    },

    sources = {
        default = { "lsp", "path", "snippets" },
    },

    snippets = {
        expand = function(snippet)
            require("luasnip").lsp_expand(snippet)
        end,
    },
    completion = {
        documentation = { auto_show = true },
        menu = {
            draw = {
                components = {
                    kind_icon = {
                        text = function(ctx)
                            local icon = ctx.kind_icon
                            if vim.tbl_contains({ "Path" }, ctx.source_name) then
                                local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                                if dev_icon then
                                    icon = dev_icon
                                end
                            else
                                icon = require("lspkind").symbolic(ctx.kind, {
                                    mode = "symbol",
                                })
                            end

                            return icon .. ctx.icon_gap
                        end,

                        -- Optionally, use the highlight groups from nvim-web-devicons
                        -- You can also add the same function for `kind.highlight` if you want to
                        -- keep the highlight groups in sync with the icons.
                        highlight = function(ctx)
                            local hl = ctx.kind_hl
                            if vim.tbl_contains({ "Path" }, ctx.source_name) then
                                local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                                if dev_icon then
                                    hl = dev_hl
                                end
                            end
                            return hl
                        end,
                    },
                },
            },
        },
    },
})

-- Formatter / Linter via none-ls
local formatting_group = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
    sources = sources,
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = formatting_group,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({
                        bufnr = bufnr,
                        filter = function(format_client)
                            return format_client.name == "null-ls"
                        end,
                    })
                end,
            })
        end
    end,
})
