-- 1. Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Immediately set this after lazy is bootstrapped but before requiring any plugins
vim.g.lspconfig_deprecation_warnings = false
-- 2. General Settings
vim.env.TERM = "xterm-256color"
vim.opt.termguicolors = true
vim.g.mapleader = " "
local opt = vim.opt
opt.clipboard = "unnamedplus"
opt.number = true
opt.relativenumber = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.signcolumn = "yes"
opt.updatetime = 250
opt.mouse = "a"
opt.shortmess:append("I")
local has_nvim_010 = vim.fn.has("nvim-0.10") == 1
local has_nvim_011 = vim.fn.has("nvim-0.11") == 1

-- 3. Splash Screen
local function show_greeting()
    if vim.fn.argc() > 0 or vim.api.nvim_buf_get_name(0) ~= "" then return end

    vim.api.nvim_set_hl(0, "SplashGreeting", { fg = "#ebdbb2", bold = true })
    vim.api.nvim_set_hl(0, "SplashSub", { fg = "#665c54" })
    vim.api.nvim_set_hl(0, "SplashDivider", { fg = "#3c3836" })
    vim.api.nvim_set_hl(0, "SplashHint", { fg = "#504945" })
    vim.api.nvim_set_hl(0, "SplashKey", { fg = "#7c6f64" })

    local hour = tonumber(os.date("%H"))
    local greeting = "Good Night, Jiaming."
    if hour >= 5 and hour < 12 then
        greeting = "Good Morning, Jiaming."
    elseif hour >= 12 and hour < 18 then
        greeting = "Good Afternoon, Jiaming."
    elseif hour >= 18 and hour < 22 then
        greeting = "Good Evening, Jiaming."
    end

    local stats = require("lazy").stats()
    local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
    local sub = stats.count .. " plugins  ·  " .. ms .. "ms"
    local divider = string.rep("─", 28)
    local hints = {
        { label = "find file  ", key = "<leader>f" },
        { label = "live grep  ", key = "<leader>g" },
        { label = "symbols    ", key = "<leader>o" },
        { label = "explorer   ", key = "-" },
    }

    local width = vim.api.nvim_win_get_width(0)
    local height = vim.api.nvim_win_get_height(0)
    local buf = vim.api.nvim_get_current_buf()
    local ns = vim.api.nvim_create_namespace("splash")

    local function center(s)
        local pad = math.max(0, math.floor((width - #s) / 2))
        return string.rep(" ", pad) .. s, pad
    end

    local total = 5 + #hints
    local top = math.max(0, math.floor((height - total) / 2) - 1)

    local output = {}
    local hl_targets = {}

    local function push(str, hl_list)
        local row = top + #output
        table.insert(output, str)
        if hl_list then
            for _, h in ipairs(hl_list) do
                table.insert(hl_targets, { row = row, group = h.group, s = h.s, e = h.e })
            end
        end
    end

    local g_str, g_pad = center(greeting)
    local sub_str, sub_pad = center(sub)
    local div_str, div_pad = center(divider)

    push(g_str, { { group = "SplashGreeting", s = g_pad, e = g_pad + #greeting } })
    push("", nil)
    push(sub_str, { { group = "SplashSub", s = sub_pad, e = sub_pad + #sub } })
    push("", nil)
    push(div_str, { { group = "SplashDivider", s = div_pad, e = div_pad + #divider } })

    for _, h in ipairs(hints) do
        local full = h.label .. h.key
        local fs, fp = center(full)
        push(fs, {
            { group = "SplashHint", s = fp, e = fp + #h.label },
            { group = "SplashKey", s = fp + #h.label, e = fp + #full },
        })
    end

    local final = {}
    for _ = 1, top do
        table.insert(final, "")
    end
    for _, l in ipairs(output) do
        table.insert(final, l)
    end

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, final)
    for _, t in ipairs(hl_targets) do
        vim.api.nvim_buf_add_highlight(buf, ns, t.group, t.row, t.s, t.e)
    end

    vim.opt_local.modifiable = false
    vim.opt_local.buftype = "nofile"
    vim.opt_local.bufhidden = "wipe"
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.cursorline = false
end

vim.api.nvim_create_autocmd("VimEnter", { callback = show_greeting })

-- 4. Live Clock
local uv = vim.uv or vim.loop
local timer = uv.new_timer()
timer:start(0, 1000, vim.schedule_wrap(function()
    vim.cmd("redrawstatus")
end))

-- 5. Plugins
local plugins = {
    -- Theme
    {
        "ellisonleao/gruvbox.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("gruvbox")
            vim.g.gruvbox_style = "dark"
            vim.g.gruvbox_contrast_dark = "hard"
            vim.g.gruvbox_italic = false
            vim.g.gruvbox_bold = true
            vim.g.gruvbox_underline = true
            vim.g.gruvbox_undercurl = true
            vim.g.gruvbox_inverse = {
                ["matchparen"] = false,
                ["visual"] = false,
                ["search"] = 1,
            }
            vim.g.gruvbox_tab_move = false
            vim.g.gruvbox_no_italic = true
            vim.g.gruvbox_no_bold = true
            vim.g.gruvbox_no_underline_curl = false
        end,
    },
    -- LSP
    {
        "neovim/nvim-lspconfig",
        enabled = has_nvim_010 and not has_nvim_011,
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
        },
        config = function()
            local lspconfig = require("lspconfig")
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "gopls", "clangd", "lua_ls" },
                automatic_enable = false,
            })

            local cmp = require("cmp")
            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                }),
            })

            local caps = require("cmp_nvim_lsp").default_capabilities()
            for _, s in ipairs({ "gopls", "clangd", "lua_ls" }) do
                lspconfig[s].setup({ capabilities = caps })
            end
        end,
    },
    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                theme = "gruvbox",
                globalstatus = true,
                section_separators = "",
                component_separators = "",
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { { "filename", path = 1 } },
                lualine_c = {},
                lualine_x = {},
                lualine_y = {
                    function()
                        return vim.fn.line(".") .. ":" .. vim.fn.col(".")
                    end,
                },
                lualine_z = {
                    function()
                        return os.date("%H:%M:%S")
                    end,
                },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {},
            },
        },
    },
    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = "BufReadPost",
        config = function()
            local ok, configs = pcall(require, "nvim-treesitter.configs")
            if not ok then
                return
            end
            configs.setup({
                ensure_installed = { "c", "go", "lua", "markdown", "rust", "cpp" },
                highlight = { enable = true },
                auto_install = true,
            })
        end,
    },
    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        enabled = has_nvim_011,
        tag = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local b = require("telescope.builtin")
            vim.keymap.set("n", "<leader>f", b.find_files)
            vim.keymap.set("n", "<leader>g", b.live_grep)
            vim.keymap.set("n", "<leader>o", b.lsp_document_symbols)
        end,
    },
    -- Oil
    {
        "stevearc/oil.nvim",
        opts = { view_options = { show_hidden = true } },
    },
    -- Autopairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
    },
    -- Auto-save
    {
        "Pocco81/auto-save.nvim",
        opts = { enabled = true },
    },
}

require("lazy").setup(plugins)

-- 6. Keybinds & Go Automation
vim.keymap.set("n", "-", "<CMD>Oil<CR>")
if not has_nvim_011 then
    vim.keymap.set("n", "<leader>f", "<CMD>find *<CR>")
    vim.keymap.set("n", "<leader>g", "<CMD>vimgrep //gj **/*<Left><Left><Left><Left><Left><Left><Left><Left><Left><CR>")
    vim.keymap.set("n", "<leader>o", "<CMD>lua vim.lsp.buf.document_symbol()<CR>")
end

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        if not has_nvim_010 then
            return
        end
        vim.lsp.buf.format({ async = false })
        local params = vim.lsp.util.make_range_params()
        params.context = { only = { "source.organizeImports" } }
        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
        for _, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
                if r.edit then
                    vim.lsp.util.apply_workspace_edit(r.edit, "utf-16")
                elseif r.command then
                    vim.lsp.buf.execute_command(r.command)
                end
            end
        end
    end,
})
