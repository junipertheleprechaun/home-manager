-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Display settings
vim.opt.wrap = false
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.o.winborder = "single"

-- Disable mouse
vim.opt.mouse = ""

-- Colorscheme
require("transparent").setup({
    extra_groups = {
        "NormalFloat",
        "NvimTreeNormal",
        "Pmenu",
        "BlinkCmpLabel",
        "BlinkCmpLabelMatch",
    },
})
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        vim.api.nvim_set_hl(0, "PmenuSel", {
            bg = "#282a36", -- formerly background
            bold = true,
        })
        vim.api.nvim_set_hl(0, "BlinkPairsYellow", { fg = "#FFFF00" })
        vim.api.nvim_set_hl(0, "BlinkPairsPurple", { fg = "#FF00FF" })
        vim.api.nvim_set_hl(0, "BlinkPairsCyan", { fg = "#00FFFF" })
    end,
})
vim.cmd.colorscheme("dracula")

-- Autopairs
require("blink.pairs").setup({
    mappings = {
        enabled = true,
        cmdline = true,
        disabled_filetypes = {},
        -- https://github.com/Saghen/blink.pairs/blob/main/lua/blink/pairs/config/mappings.lua#L14
        pairs = {
            ["<"] = {
                {
                    "<",
                    ">",
                    when = function(ctx)
                        return ctx.ts:whitelist("angle").matches
                    end,
                    languages = { "rust", "typescript" },
                },
            },
        },
    },
    highlights = {
        enabled = true,
        -- requires require('vim._extui').enable({}), otherwise has no effect
        cmdline = true,
        groups = {
            "BlinkPairsYellow",
            "BlinkPairsPurple",
            "BlinkPairsCyan",
        },
        unmatched_group = "BlinkPairsUnmatched",

        -- highlights matching pairs under the cursor
        matchparen = {
            enabled = true,
            -- known issue where typing won't update matchparen highlight, disabled by default
            cmdline = false,
            -- also include pairs not on top of the cursor, but surrounding the cursor
            include_surrounding = false,
            group = "BlinkPairsMatchParen",
            priority = 250,
        },
    },
    debug = false,
})

-- Markdown-specific settings
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en_us"
    end,
})

-- Clipboard
vim.g.clipboard = "osc52"
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        if vim.v.event.operator == "y" then
            local yanked = vim.fn.getreg('"')
            local encoded = vim.fn.system("base64", yanked)
            local esc = string.char(27)
            local bel = string.char(7)
            local osc52 = string.format("%s]52;c;%s%s", esc, encoded:gsub("\n", ""), bel)
            vim.api.nvim_chan_send(vim.v.stderr, osc52)
        end
    end,
})
