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
cmd 'packadd paq-nvim'                                              -- load the package manager
local paq = require('paq-nvim').paq                                 -- a convenient alias
paq {'savq/paq-nvim', opt = true}                                   -- paq-nvim manages itself
paq {'nvim-treesitter/nvim-treesitter'}                             -- Tree Sitter
paq {'kyazdani42/nvim-web-devicons'}                                -- Icons - others depend on this
paq {'marko-cerovac/material.nvim'}                                 -- Theme with tree sitter support
paq {'neovim/nvim-lspconfig'}                                       -- lsp config
paq {'nvim-lua/plenary.nvim'}                                       -- Helper functions other plugins depend on
paq {'lewis6991/gitsigns.nvim'}                                     -- Adds git info to gutter
paq {'hrsh7th/nvim-compe'}                                          -- Autocomplete
paq {'kabouzeid/nvim-lspinstall'}                                   -- Adds :LspInstall back in
paq {'norcalli/nvim-colorizer.lua'}                                 -- Add color to color codes
paq {'hoob3rt/lualine.nvim'}                                        -- Status line
paq {'lewis6991/spellsitter.nvim'}                                  -- Spell check [Not WORKING? 05/20/2021]
paq {'yamatsum/nvim-cursorline'}                                    -- Highlights current word and matching words as cursor moves
paq {'akinsho/nvim-bufferline.lua'}                                 -- Adds gui-like tabs
paq {'kyazdani42/nvim-tree.lua'}                                    -- File Manager
paq {'folke/which-key.nvim'}                                        -- Displays key commands
paq {'b3nj5m1n/kommentary'}                                         -- selection comments
paq {'windwp/nvim-ts-autotag'}                                      -- Auto pair html like tags
paq {'windwp/nvim-autopairs'}                                       -- Bracket Autopair
paq {'p00f/nvim-ts-rainbow'}                                        -- Color match bracket pairs
paq {'blackCauldron7/surround.nvim'}                                -- Allows setting/chaing around word
paq {'rmagatti/auto-session'}                                       -- Simple sessions, saves on close, restore on open
paq {'folke/todo-comments.nvim'}                                    -- Comment highligher for todo, etc
paq {'nvim-lua/popup.nvim'}                                         -- Popups used by Telescope
paq {'nvim-telescope/telescope.nvim'}                               -- Nvim Telescope, nuf said
paq {'glepnir/lspsaga.nvim'}                                        -- Nice interface to LSP info
paq {'lukas-reineke/indent-blankline.nvim', branch = 'lua'}         -- Visual indent marking

--------------------  OPTIONS  ----------------------------
local indent = 4
cmd 'colorscheme material'                              -- Set theme
g.material_style = "darker"                             -- Set version of theme (darker, ligher, oceanic, palenight, deep ocean)
g.mapleader = " "                                       -- Space as Leader
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
--Repeat some options as they might not be set with lua yet...
cmd('set expandtab')
cmd('set shiftwidth=4')
cmd('set smartindent')
cmd('set tabstop=4')

-------------------- MAPPINGS ------------------------------
-- <Tab> to navigate the completion menu
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})

-- Toggle nvim-tree and focus back to window
map('', '<leader>n', ':NvimTreeToggle<CR><C-W>w', {silent = true})

-- Tab bufferline navigate
map('n', '<leader>[', ':BufferLineCyclePrev<CR>', {silent = true})
map('n', '<leader>]', ':BufferLineCycleNext<CR>', {silent = true})

-- Ctrl+S to save
map('n', '<C-s>', ':w<CR>')

-- Quit vim
map('n', '<leader>qq', ':qa<CR>')

-- LspSaga
map('n', '<C-f>', '<cmd>lua require("lspsaga.action").smart_scroll_wtih_sage(1)<CR>')
map('n', '<C-b>', '<cmd>lua require("lspsaga.action").smart_scroll_wtih_sage(-1)<CR>')
map('n', 'K', '<cmd>lua require("lspsaga.hover").render_hover_doc()<CR>')
map('n', 'gs', '<cmd>lua require("lspsaga.signaturehelp").signature_help()<CR>')
map('n', 'gr', '<cmd>lua require("lspsaga.rename").rename()<CR>')
map('n', 'gd', '<cmd>lua require("lspsaga.provider").preview_definition()<CR>')
map('n', 'gh', '<cmd>lua require("lspsaga.provider").lsp_finder()<CR>')
map('n', '<leader>ca', '<cmd>lua require("lspsaga.codeaction").code_action()<CR>')
map('n', '<leader>cg', '<cmd>lua require("lspsaga.diagnostic").show_line_diagnostics()<CR>')
map('n', '<A-i>', '<CMD>lua require("lspsaga.floaterm").open_float_terminal()<CR>')
map('t', '<A-i>', '<C-\\><C-n><CMD>lua require("lspsaga.floaterm").close_float_terminal()<CR><C-w>l')

-------------------- TREE-SITTER ---------------------------
local ts = require 'nvim-treesitter.configs'
ts.setup {
    ensure_installed = 'maintained',
    highlight = {enable = true},
    rainbow = {
        enable = true,
        extend_mode = true,
        max_file_lines = 1000
    }
}

--------------------  PLUGIN SETUP  ------------------------
require'gitsigns'.setup()
require'colorizer'.setup()
require'spellsitter'.setup()
require'which-key'.setup()
require('kommentary.config').use_extended_mappings()   -- Use gc/gcc to comment
require('nvim-ts-autotag').setup()
require('nvim-autopairs').setup()
require('surround').setup({})
require('auto-session').setup({pre_save_cmds = {'tabdo NvimTreeClose'}, post_restore_cmds = {'tabdo NvimTreeOpen'}})
require('todo-comments').setup()
require('lspsaga').init_lsp_saga()

--------------------  nvim-bufferline SETUP ----------------
require'bufferline'.setup{
    options = {
        offsets = {{filetype = "NvimTree", text = "File Explorer", highlight = "Directory", text_align = "center"}}
    }
}

--------------------  nvim-tree SETUP ----------------
g.nvim_tree_width = 30
g.nvim_tree_auto_open = 1
g.nvim_tree_tab_open = 1
g.nvim_tree_follow = 1

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
--Most of added line stuff comes form evil_lualine
--https://gist.github.com/hoob3rt/b200435a765ca18f09f83580a606b878
require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'material-nvim',
    component_separators = {'???', '???'},
    section_separators = {'???', '???'},
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {
        {
            function()
                local function format_file_size(file)
                local size = vim.fn.getfsize(file)
                if size <= 0 then return '' end
                    local sufixes = {'b', 'k', 'm', 'g'}
                    local i = 1
                    while size > 1024 do
                        size = size / 1024
                        i = i + 1
                    end
                    return string.format('%.1f%s', size, sufixes[i])
                end
                local file = vim.fn.expand('%:p')
                if string.len(file) == 0 then return '' end
                    return format_file_size(file)
                end,
                condition = function() return vim.fn.empty(vim.fn.expand('%:t')) ~= 1 end
        },
        'filename',
        {
            'diagnostics',
            sources = {'nvim_lsp'},
            symbols = {error = '??? ', warn = '??? ', info = '??? '},
            color_error = "#EC5F67",
            color_warn = "#ECBE7B",
            color_info = "#008080"
        }
    },
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {
        {
            'diff',
            symbols = {added = '??? ', modified = '??? ', removed = '??? '},
            color_added = "#98BE65",
            color_modified = "#FF8800",
            color_removed = "#EC5F67",
            condition = function() return vim.fn.winwidth(0) > 80 end
        },
        'progress'},
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
  extensions = {'nvim-tree'}
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
