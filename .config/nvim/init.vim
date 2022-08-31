" -------
" PLUGINS
" -------

call plug#begin()

" Telecope.
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" UX.
Plug 'akinsho/toggleterm.nvim'
" Plug 'Alex-vZyl/toggleterm.nvim', {'tag' : 'v2.*'}
Plug 'dstein64/nvim-scrollview'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'mg979/vim-visual-multi'
Plug 'rcarriga/nvim-notify'	
Plug 'majutsushi/tagbar'
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'akinsho/bufferline.nvim'
Plug 'karb94/neoscroll.nvim'
Plug 'mhinz/vim-startify'
Plug 'Pocco81/true-zen.nvim' " Zen mode!

" Git.
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'kdheepak/lazygit.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'sindrets/diffview.nvim'

" Neovim helpers.
Plug 'folke/which-key.nvim'
Plug 'sudormrfbin/cheatsheet.nvim'

" Filesystem & Searching.
Plug 'kyazdani42/nvim-tree.lua'
Plug 'BurntSushi/ripgrep'
Plug 'brooth/far.vim'

" General langage.
Plug 'nvim-treesitter/nvim-treesitter'  " Syntax highlighting.
Plug 'dense-analysis/ale'  " Linting engine.
Plug 'preservim/nerdcommenter'
Plug 'tpope/vim-commentary'  " Allow commenting with <C-/>.
Plug 'mhartington/formatter.nvim'

" Main LSP engine.
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}

" VIM Script.
Plug 'prabirshrestha/vim-lsp'

" Julia.
Plug 'JuliaEditorSupport/julia-vim'
Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh'}

" Lua.
Plug 'sumneko/lua-language-server' 

" Themes.
Plug 'sainnhe/gruvbox-material'
Plug 'morhetz/gruvbox'
Plug 'folke/tokyonight.nvim'
Plug 'EdenEast/nightfox.nvim'
Plug 'sainnhe/everforest'
Plug 'sainnhe/edge'
Plug 'shaunsingh/nord.nvim'
Plug 'dracula/vim'
Plug 'joshdick/onedark.vim'

call plug#end()

" ----------
" LUA CONFIG
" ----------

lua <<EOF

----------------
-- Bufferline --
----------------

require 'bufferline'.setup {
    options = {    
        mode = "buffers",
        diagnostics = "coc",   
        offsets = { 
            {
                filetype = "NvimTree",
                text = "File Explorer",
                highlight = "Directory",
                text_align = "center"
            }
        },
        custom_areas = {
          right = function()
            local result = {}
            local seve = vim.diagnostic.severity
            local error = #vim.diagnostic.get(0, {severity = seve.ERROR})
            local warning = #vim.diagnostic.get(0, {severity = seve.WARN})
            local info = #vim.diagnostic.get(0, {severity = seve.INFO})
            local hint = #vim.diagnostic.get(0, {severity = seve.HINT})
    
            if error ~= 0 then
              table.insert(result, {text = "  " .. error, guifg = "#EC5241"})
            end
    
            if warning ~= 0 then
              table.insert(result, {text = "  " .. warning, guifg = "#EFB839"})
            end
    
            if hint ~= 0 then
              table.insert(result, {text = "  " .. hint, guifg = "#A3BA5E"})
            end
    
            if info ~= 0 then
              table.insert(result, {text = "  " .. info, guifg = "#7EA9A7"})
            end
            return result
          end,
        },
        separator_style = "padded_slant",
        -- separator_style = "thick",
    }
}

-------------------
-- Lualine setup --
-------------------

require 'lualine'.setup {
    options = { 
        disabled_filetypes = { "NvimTree", "startify" }
        },
    extensions = {
        "toggleterm",
        "nvim-tree"
    }
}

--------------
-- Zen mode --
--------------

require 'true-zen'.setup {
    modes = {
        ataraxis = {

        }
    },
    integrations = {
        lualine = true
    }
}

---------------------
-- Setup neoscroll --
---------------------

require 'neoscroll'.setup {
    erasing_function = 'quadratic'
}
local t = { }
t['<C-u>'] = {'scroll', {'-vim.wo.scroll * 2', 'true', '400', nil}}
t['<C-d>'] = {'scroll', { 'vim.wo.scroll * 2', 'true', '400', nil}}
require('neoscroll.config').set_mappings(t)

-----------------
-- Indentation --
-----------------

require 'indent_blankline'.setup {
    show_end_of_line = true,
    show_current_context = true,
    show_current_context_start = true,
    filetype_exclude = { 'NvimTree', 'startify' }
}

----------------------------
-- Formatter setup [TODO] -- 
----------------------------

require 'formatter'.setup {}    

---------------------
-- Setup telescope --
---------------------

local ts = require 'telescope'
ts.setup({
    defaults = {
        sort_mru = true,
        sorting_strategy = 'ascending',
        layout_config = {
            prompt_position = 'top' 
        }
    }
})
ts.load_extension("notify")

---------------------------------
-- Setup default notifications -- 
---------------------------------

local notify = require("notify")
notify.setup({})
vim.notify = notify

----------------------
-- Setup toggleterm --
----------------------

require("toggleterm").setup {
    on_open = function(term)
        vim.cmd("startinsert")
    end,
    direction = "float",
    size = 13,
    float_opts = {
        border = 'single',
        winblend = 0,
    }
}

-----------------------------
-- Lazygit with toggleterm --
-----------------------------
 
local Terminal  = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
function _lazygit_toggle()
  lazygit:toggle()
end
vim.api.nvim_set_keymap("n", "<C-G>", "<Cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("t", "<C-G>", "<Cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})

----------------------------
-- BTop++ with toggleterm --
----------------------------

local Terminal  = require('toggleterm.terminal').Terminal
-- local btop = Terminal:new({ cmd = "btop --utf-force", hidden = true, direction = "float" })
local btop = Terminal:new({ cmd = "btop", hidden = true, direction = "float" })
function _btop_toggle()
  btop:toggle()
end
vim.api.nvim_set_keymap("n", "<C-B>", "<Cmd>lua _btop_toggle()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("t", "<C-B>", "<Cmd>lua _btop_toggle()<CR>", {noremap = true, silent = true})

--------------------------
-- Fish with toggleterm --
--------------------------

local Terminal  = require('toggleterm.terminal').Terminal
local fish = Terminal:new({ cmd = "fish", hidden = true, direction = "horizontal" })
function _fish_toggle()
  fish:toggle()
end
vim.api.nvim_set_keymap("n", "<F3>", "<Cmd>lua _fish_toggle()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("t", "<F3>", "<Cmd>lua _fish_toggle()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("v", "<F3>", "<Cmd>lua _fish_toggle()<CR>", {noremap = true, silent = true})

----------------
-- Setup tree --
----------------

require 'nvim-tree'.setup {
    view = {
        mappings = {
            list = {
                -- Allow moving out of the explorer.
                { key = "<C-i>", action = "toggle_file_info" },
                { key = "<C-k>", action = "" }
            }
        },
        width = 35
    },
    auto_reload_on_write = true,
}

---------------------------
-- Configure tree sitter --
---------------------------

require 'nvim-treesitter.configs'.setup {

    -- A list of parser names, or "all"
    ensure_installed = { "c", "lua", "rust", "cpp", "julia", "python" },
    -- ensure_installed = {  },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    auto_install = true,

    -- List of parsers to ignore installing (for "all")
    -- ignore_install = { "" },

    highlight = {

        -- `false` will disable the whole extension
        enable = true,

        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        -- disable = { "" },

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
}

EOF

" ----------
" APPEARANCE
" ----------

" Neovide settings.
" let g:neovide_transparency=0.95
let g:neovide_transparency=1
let g:neovide_fullscreen=v:false
let g:neovide_profiler=v:false
let g:neovide_cursor_animation_length = 0.0
let g:neovide_cursor_animation_size=0.95
let g:neovide_scroll_animation_length = 0.0

" Setup themes.
let g:gruvbox_material_foreground = 'original'
let g:gruvbox_material_background = 'hard'
let background = 'dark'
let g:everforest_background = 'hard'
:colorscheme gruvbox-material

" Scrollbar settings.
:let g:scrollview_column =1
:let g:hide_on_intersect =1
:let g:scrollview_excluded_filetypes = ['nerdtree', 'NvimTree']

" Font.
set guifont=JetBrainsMono\ Nerd\ Font:h11.75

" Explicitly enable efm langserver.
let g:lsp_settings = {
\  'efm-langserver': {
\    'disabled': 0,
\   },
\ }

" ----------------
" GENERAL SETTINGS
" ----------------

" Enable colors for neovim usage in the terminal.
" This is not fixing the issue?
set termguicolors

" Clipboard. 
set clipboard+=unnamedplus 

" Enable mouse input.
set mouse=a

" Syntax.
syntax on
set number
set cursorline
set hlsearch
set ignorecase
set smartcase

" Coc setup.
set pumheight=10 " Limit the height of the seggestion window.

" Setup tabbing.
set tabstop	=4
set softtabstop=4
set shiftwidth =4
set textwidth	=0
set expandtab
set autoindent

" Show matching brackets.
set showmatch

" Disable text wrap around.
set nowrap

" Setup bufferline.
set termguicolors

" Allow FAR to undo.
let g:far#enable_undo=1

" Disable VM exit message and statusline.
let g:VM_set_statusline = 0
let g:VM_silent_exit = 1

" Setup startify.
let g:startify_custom_header =
          \ 'startify#center(startify#fortune#cowsay())'
let g:startify_lists = [
    \ { 'type': 'sessions',  'header': ['   Sessions']       },
    \ { 'type': 'dir',       'header': ['   Recents']       },
    \ { 'type': 'files',     'header': ['   Global Recents']         },
\ ]

" ----------
" KEYMAPPING
" ----------

" Barbar.
nnoremap <silent> <C-<> <Cmd>BufferLineMovePrev<CR>
nnoremap <silent> <C->> <Cmd>BufferLineMoveNext<CR>
nnoremap <silent> <C-,> <Cmd>BufferLineCyclePrev<CR>
nnoremap <silent> <C-.> <Cmd>BufferLineCycleNext<CR>
nnoremap <silent> <C-?> <Cmd>lua bdelete<CR>
nnoremap <silent> db <Cmd>BufferLinePickClose<CR>
nnoremap <silent> gb :BufferLinePick<CR>

" File explorer.
nnoremap <silent> <F2> <Cmd>Telescope find_files<CR>
inoremap <silent> <F2> <Cmd>Telescope find_files<CR>
vnoremap <silent> <F2> <Cmd>Telescope find_files<CR>
tnoremap <silent> <F2> <Cmd>Telescope find_files<CR>

" Toggle the file explorer.
nnoremap <silent> <F1> <Cmd>NvimTreeToggle<CR>
inoremap <silent> <F1> <Cmd>NvimTreeToggle<CR>
vnoremap <silent> <F1> <Cmd>NvimTreeToggle<CR>
tnoremap <silent> <F1> <Cmd>NvimTreeToggle<CR>

" Search for old files.
nnoremap <silent> <C-t> <Cmd>Telescope oldfiles<CR>
inoremap <silent> <C-t> <Cmd>Telescope oldfiles<CR>
vnoremap <silent> <C-t> <Cmd>Telescope oldfiles<CR>
tnoremap <silent> <C-t> <Cmd>Telescope oldfiles<CR>

" Cheatsheet.
nnoremap <silent> <F12> <Cmd>Cheatsheet<CR>
inoremap <silent> <F12> <Cmd>Cheatsheet<CR>
vnoremap <silent> <F12> <Cmd>Cheatsheet<CR>
tnoremap <silent> <F12> <Cmd>Cheatsheet<CR>

" Sessions.
nnoremap <silent> <F5> <Cmd>SSave<CR> " <Cmd>lua vim.notify(" Saved current session.", "success", { title = " Session"} )<CR>

" Moving windows.
nnoremap <silent> <C-h> <Cmd>wincmd h<CR>
nnoremap <silent> <C-j> <Cmd>wincmd j<CR>
nnoremap <silent> <C-k> <Cmd>wincmd k<CR>
nnoremap <silent> <C-l> <Cmd>wincmd l<CR>
" Allow moving out of the terminal.
tnoremap <silent> <C-h> <Cmd>wincmd h<CR>
tnoremap <silent> <C-j> <Cmd>wincmd j<CR>
tnoremap <silent> <C-k> <Cmd>wincmd k<CR>
tnoremap <silent> <C-l> <Cmd>wincmd l<CR>

" Ensure we are in normal mode when leaving the terminal.
augroup LeavingTerminal
autocmd! 
autocmd TermLeave <silent> <Esc>
augroup end

" Terminal mappings.
au BufEnter * if &buftype == 'terminal' | :startinsert | endif " Make terminal default mode insert mode.
tnoremap <silent> <Esc> <C-\><C-n>

" Commenting.
nnoremap <silent> <C-/> <Cmd>Commentary<CR>
inoremap <silent> <C-/> <Cmd>Commentary<CR>
vnoremap <silent> <C-/> <Cmd>Commentary<CR>

" Saving.
nnoremap <silent> <C-s> <Cmd>w!<CR> <Cmd>lua vim.notify(" Saved to \"" .. vim.fn.expand('%') .. "\".", "success", { render = "minimal"} )<CR>
vnoremap <silent> <C-s> <Cmd>w!<CR> <Cmd>lua vim.notify(" Saved to \"" .. vim.fn.expand('%') .. "\".", "success", { render = "minimal"} )<CR>
inoremap <silent> <C-s> <Cmd>w!<CR> <Cmd>lua vim.notify(" Saved to \"" .. vim.fn.expand('%') .. "\".", "success", { render = "minimal"} )<CR>

" Buffers.
nnoremap <silent> <C-TAB> <Cmd>Telescope buffers<CR>
inoremap <silent> <C-TAB> <Cmd>Telescope buffers<CR>
tnoremap <silent> <C-TAB> <Cmd>Telescope buffers<CR>
vnoremap <silent> <C-TAB> <Cmd>Telescope buffers<CR>

" Finding.
nnoremap <silent> <C-f> <Cmd>Telescope current_buffer_fuzzy_find previewer=false<CR>
inoremap <silent> <C-f> <Cmd>Telescope current_buffer_fuzzy_find previewer=false<CR>
vnoremap <silent> <C-f> <Cmd>Telescope current_buffer_fuzzy_find previewer=false<CR>

" Disable the search highlight when hitting esc.
nnoremap <silent> <Esc> <Cmd>noh<CR>
inoremap <silent> <Esc> <Cmd>stopinsert<CR> <Cmd>noh<CR>
vnoremap <silent> <Esc> <Cmd>noh<CR>

" Redo and undo.
nnoremap <silent> <C-Z> <Cmd>undo<CR>
inoremap <silent> <C-Z> <Cmd>undo<CR>
vnoremap <silent> <C-Z> <Cmd>undo<CR>
nnoremap <silent> <C-Y> <Cmd>redo<CR>
inoremap <silent> <C-Y> <Cmd>redo<CR>
vnoremap <silent> <C-Y> <Cmd>redo<CR>

" Zen mode.
nnoremap <silent> <C-a> <Cmd>TZAtaraxis<CR>
vnoremap <silent> <C-a> <Cmd>TZAtaraxis<CR>
inoremap <silent> <C-a> <Cmd>TZAtaraxis<CR>

" -------------------------
" RUST PLUGIN CONFIGURARION
" -------------------------

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

"-----------"
" COC SETUP "
"-----------"

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  " nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  " nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  " inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  " inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  " vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  " vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
" nmap <silent> <C-s> <Plug>(coc-range-select)
" xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

"------"
" MISC "
"------"

" For stuff that has to be run at the end.

" Ensure cmd is not larger than it needs to be.
set cmdheight =1

" For some reason neovim is not laoding the init file properly, so I have to
" add this so that it gets reloaded on startup.  I am assuming there is something wrong in my config.
if !exists('$INIT_RELOADED')
    let $INIT_RELOADED = 'TRUE'
    so ~/.config/nvim/init.vim 
end
