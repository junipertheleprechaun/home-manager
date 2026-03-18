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
        "CmpItemAbbr",
        "CmpItemAbbrMatch",
    },
})

local kinds = {
    "Text",
    "Method",
    "Function",
    "Constructor",
    "Field",
    "Variable",
    "Class",
    "Interface",
    "Module",
    "Property",
    "Unit",
    "Value",
    "Enum",
    "Keyword",
    "Snippet",
    "Color",
    "File",
    "Reference",
    "Folder",
    "EnumMember",
    "Constant",
    "Struct",
    "Event",
    "Operator",
    "TypeParameter",
}

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        --vim.api.nvim_set_hl(0, "PmenuSel", {
        --    bg = "#282a36", -- formerly background
        --    bold = true,
        --})
        for _, kind in ipairs(kinds) do
            vim.api.nvim_set_hl(0, "CmpItemKind" .. kind .. "Icon", { link = "CmpItemKind" .. kind })
        end
    end,
})
vim.cmd.colorscheme("dracula")

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
