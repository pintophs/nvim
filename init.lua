-- Vim Options
vim.o.number = true          -- Line numbers
vim.o.relativenumber = true  -- Relative numbers
vim.o.tabstop = 2            -- TAB character will *look* like 2 spaces
vim.o.shiftwidth = 2         -- How many spaces to insert when indenting (via >> or auto-indent)
vim.o.expandtab = true       -- Insert spaces instead of actual TAB characters
vim.o.smartindent = true     -- Automatically add indentation in code-like files
vim.o.termguicolors = true   -- Enables full RGB colors in the terminal
vim.o.cursorline = true      -- Show which line your cursor is on

-- Vim Shortcuts
vim.g.mapleader = ' '                       -- Space as leader key
vim.g.maplocalleader = ' '
vim.keymap.set("n", "<leader>w", ":w<CR>")  -- <leader>w -> saves the file (:w)
vim.keymap.set("n", "<leader>q", ":q<CR>")  -- <leader>q -> quits the file (:q)

-- Set to false if you do not have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true 

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Save undo history
vim.o.undofile = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Clear highlights on search when pressing <Esc> in normal mode
-- See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')


-- Highlight when yanking text
-- See `:help vim.hl.on_yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Plugin Manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- Catppuccin theme
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    "catppuccin/nvim",
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
    require("catppuccin").setup({
      flavour = "macchiato", -- latte, frappe, macchiato, mocha
      no_italic = true,  -- disables *all* italics, comments won't be in italic anymore
      integrations = {
        treesitter = true,
        native_lsp = {
          enabled = true,
        },
      },
    })

    -- Apply the theme
    vim.cmd.colorscheme "catppuccin"
    end,
  },

  -- LuaLine
  {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        theme = "catppuccin",     -- matches your colorscheme
        section_separators = "",  -- minimal style
        component_separators = "",
      },
      sections = {
        lualine_a = { "mode" },     -- Shows current vim mode
        lualine_b = { "branch" },   -- Shows current Git branch
        lualine_c = { "filename" }, -- Shows filename
        lualine_x = { "diagnostics", "filetype" }, -- Shows LSP errors/warnings
        lualine_y = { "progress" },  -- Shows the current file type
        lualine_z = { "location" },  -- Shows percentage and line:column of the cursor
      },
    })
  end,
  },

  -- Tree-sitter
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = {
        'bash', 'c', 'cpp', 'diff', 'fortran',
        'lua', 'luadoc', 'markdown', 'markdown_inline',
        'python', 'query', 'vim', 'vimdoc', 'yaml'
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        -- additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },
})

