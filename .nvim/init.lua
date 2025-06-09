-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
          { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
          { out, "WarningMsg" },
          { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

if vim.g.neovide then
	vim.g.neovide_remember_window_size = true
	vim.g.neovide_cursor_animation_length = 0
	vim.g.neovide_cursor_animation_in_insert_mode = false
	vim.g.neovide_cursor_animate_command_line = false
	vim.g.neovide_refresh_rate_idle = 5
	vim.g.neovide_hide_mouse_when_typing = true 
	vim.g.neovide_position_animation_length = 0
	vim.g.neovide_padding_top = 6
	vim.g.neovide_padding_bottom = 6
	vim.g.neovide_padding_right = 6
	vim.g.neovide_cursor_trail_size = 0
	vim.g.neovide_cursor_antialiasing = false
	vim.g.neovide_cursor_vfx_mode = ""
	vim.g.neovide_padding_left = 6
	vim.g.neovide_scroll_animation_length = 0

end

vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")

vim.g.mapleader = " " -- <Space>
vim.g.maplocalleader = "\\"

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.wrap = false
vim.o.termguicolors = true
vim.o.cursorline = true
vim.o.guifont = "Roboto Mono:h12"
vim.opt.number = true

local line_number_toggle = vim.api.nvim_create_augroup("numbertoggle", {})
vim.api.nvim_create_autocmd(
	{"BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter"}, 
	{
		group = line_number_toggle,
		callback = function() 
				if vim.opt.number:get() and vim.api.nvim_get_mode() ~= "i" then
					vim.opt.relativenumber = true
				end
			   end
	}
)

vim.api.nvim_create_autocmd(
	{"BufLeave", "FocusLost", "InsertEnter", "WinLeave", "CmdlineEnter"},
	{
		group = line_number_toggle,
		callback = function()
				if vim.opt.number:get() then
					vim.opt.relativenumber = false
					vim.cmd("redraw")
				end
			   end
	}
)
	
require("lazy").setup({
    spec = {
        -- add your plugins here
        { 
            "sainnhe/gruvbox-material",
            lazy = false,
            priority = 1000,
            config = function()
                        vim.cmd.colorscheme('gruvbox-material')
                        vim.g.gruvbox_material_enable_italic = false
                        vim.g.gruvbox_material_background = 'hard'
                        vim.g.gruvbox_material_foreground = 'original'
                        vim.g.gruvbox_material_disable_italic_comment = 1
                        vim.g.gruvbox_material_enable_bold = 1
                      end
        },
        {
            "Pocco81/auto-save.nvim",
            config = function() 
                        require("auto-save").setup {
                            enabled = true
                        }
	 	     end
        },
        {
            "windwp/nvim-autopairs",
            event = "InsertEnter",
            config = true,
        },
        {
            "tris203/precognition.nvim",
            event = "VeryLazy",
            opts = {
                startVisible = true,
                hints = {
                    Caret = { text = "^", prio = 2 },
                    Dollar = { text = "$", prio = 1},
                    MatchingPair = { text = "%", prio = 5 },
                    Zero = { text=  "0", prio = 1 },
                    w = { text = "w", prio = 10 },
                    b = { text = "b", prio = 9 },
                    e = { text = "e", prio = 8 },
                    W = { text = "W", prio = 7 },
                    B = { text = "B", prio = 6 },
                    E = { text = "E", prio = 5 },
                },
                gutterHints = {
                    G = { text = "G", prio = 10 },
                    gg = { text = "gg", prio = 9 },
                    PrevParagraph = { text = "{", prio = 8 },
                    NextParagraph = { text = "}", prio = 8 },
                },
            },
        },
        {
            "nvim-lualine/lualine.nvim",
            dependencies = {
                "nvim-tree/nvim-web-devicons"
            },
        },
        {
            "nvim-telescope/telescope.nvim",
            tag = "0.1.8",
            dependencies = {
                "nvim-lua/plenary.nvim"
            },
            config = function()
                        local builtin = require('telescope.builtin')
                        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
                        vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
                        vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
                        vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
                     end
        },
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            config = function()
                        local configs = require("nvim-treesitter.configs")
                        configs.setup({
                            sync_install = false,
                            ensure_installed = {
                                "c",
                                "lua",
                                "vim",
                                "vimdoc",
                                "markdown_inline",
                                "markdown",
                                "dart",
                                "cpp",
                                "json",
                                "html",
                                "css",
                                "python",
                                "yaml",
                                "xml",
                                "gitignore",
                                "properties",
                                "http",
                                "ini",
                                "gitattributes",
                                "gitcommit",
                                "bash",
                                "cmake",
                                "make"
                            },
                            auto_install = true,
                            highlight = { enable = true },
                        })
                      end
        },
    },
    checker = { enabled = true },
})

require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'auto',
    component_separators = "|",
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = true, 
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
      refresh_time = 14,
      events = {
        'WinEnter',
        'BufEnter',
        'BufWritePost',
        'SessionLoadPost',
        'FileChangedShellPost',
        'VimResized',
        'Filetype',
        'CursorMoved',
        'CursorMovedI',
        'ModeChanged',
      },
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
