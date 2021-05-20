-------------------- HELPERS -------------------------------
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables

local windowOpt = vim.wo
local globalOpt = vim.o
local bufferOpt = vim.bo

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-------------------- PLUGINS -------------------------------
cmd 'packadd paq-nvim'                                  -- load the package manager
local paq = require('paq-nvim').paq                     -- a convenient alias
paq {'savq/paq-nvim', opt = true}                       -- paq-nvim manages itself
paq {'kyazdani42/nvim-web-devicons'}                    -- Icons - others depend on this
paq {'marko-cerovac/material.nvim'}                     -- Theme with tree sitter support
paq {'neovim/nvim-lspconfig'}                           -- lsp config
paq {'nvim-lua/plenary.nvim'}                           -- Helper functions other plugins depend on
paq {'lewis6991/gitsigns.nvim'}                         -- Adds git info to gutter
paq {'hrsh7th/nvim-compe'}                              -- Autocomplete
paq {'nvim-treesitter/nvim-treesitter'}                 -- Tree Sitter
paq {'kabouzeid/nvim-lspinstall'}                       -- Adds :LspInstall back in
paq {'norcalli/nvim-colorizer.lua'}                     -- Add color to color codes
paq {'hoob3rt/lualine.nvim'}                            -- Status line
paq {'lewis6991/spellsitter.nvim'}                      -- Spell check
paq {'yamatsum/nvim-cursorline'}                        -- Highlights current word and matching words as cursor moves
--paq {'akinsho/nvim-bufferline.lua'}                     -- Adds gui-like tabs
paq {'kyazdani42/nvim-tree.lua'}                        -- File Manager
paq {'folke/which-key.nvim'}                            -- Displays key commands

--------------------  OPTIONS  ----------------------------
local indent = 4
cmd 'colorscheme material'                              -- Set theme
g.material_style = "darker"                             -- Set version of theme (darker, ligher, oceanic, palenight, deep ocean)
g.mapleader = " "
globalOpt.timeoutlen = 800                              -- Key map completion timeout
globalOpt.completeopt = 'menuone,noinsert,preview'      -- Completion options
globalOpt.hidden = true                                 -- Enable modified buffers in background
globalOpt.ignorecase = true                             -- Ignorecase in searchs
globalOpt.smartcase = true                              -- ^Overrides if caps in search
globalOpt.hlsearch = false                              -- Un-highlight search after done with it
globalOpt.shiftround = true                             -- Round indent length
globalOpt.sidescrolloff = 4                             -- Scrolloff but for vertical
globalOpt.foldlevelstart = 99                           -- Default no folded code
globalOpt.confirm = true                                -- Ask to save before quit
globalOpt.termguicolors = true                          -- enable True Color support
globalOpt.wildmode = 'longest,list,full'                -- Command-line completion mode
globalOpt.wildmenu = true                               -- Enable wildmenu
globalOpt.modeline = true                               -- Enable vim modeline
globalOpt.autoread = true                               -- Reload file if has changed while open
globalOpt.scrolloff = 20                                -- keep x lines of code above/below current line - 24 at my current res is centered
globalOpt.swapfile = false                              -- Disable swapfile, store buffers in memory
globalOpt.laststatus = 2                                -- Show statuslines on all windows
globalOpt.mouse = 'a'                                   -- Enable mouse support always
--buffer
bufferOpt.expandtab = true                              -- Tab inserts spaces
bufferOpt.shiftwidth = indent                           -- Size of indent
bufferOpt.smartindent = true                            -- Auto indent
bufferOpt.tabstop = indent                              -- Num of spaces that == tab
--window
windowOpt.number = true                                 -- Show line numbers
windowOpt.relativenumber = true                         -- Relative line numbers
windowOpt.colorcolumn = '80'                            -- Draw bar at 80 chars
windowOpt.linebreak = true                              -- Set newline to indent level of current line/wraps long lines without adding newlines
windowOpt.breakindent = true                            -- ^
windowOpt.list = true                                   -- Shows some invisible chars

-------------------- MAPPINGS ------------------------------
-- <Tab> to navigate the completion menu
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})

-------------------- TREE-SITTER ---------------------------
local ts = require 'nvim-treesitter.configs'
ts.setup {ensure_installed = 'maintained', highlight = {enable = true}}

--------------------  PLUGIN SETUP  ------------------------
require'gitsigns'.setup()
require'colorizer'.setup()
require'spellsitter'.setup()
require'which-key'.setup()

--------------------  nvim-bufferline SETUP ----------------
--require'bufferline'.setup{}

--------------------  nvim-compue SETUP --------------------
require('compe').setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
  };
}

--------------------  lualine SETUP -----------------------
require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'material-nvim',
    component_separators = {'', ''},
    section_separators = {'', ''},
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
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
  extensions = {}
}

--------------------  nvim-lspinstall SETUP ---------------
local function setup_servers()
  require'lspinstall'.setup()
  local servers = require'lspinstall'.installed_servers()
  for _, server in pairs(servers) do
    require'lspconfig'[server].setup{}
  end
end
setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end