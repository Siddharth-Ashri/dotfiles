vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.laststatus = 3

vim.opt.cc = '120'
vim.opt.modeline = false
vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.relativenumber = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.autoindent = true
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.guicursor = ''
vim.opt.smartindent = true
vim.opt.hlsearch = true

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<leader>qs', function ()
    require('persistence').load()
end, { desc = '[Q]uick [S]ave' })
vim.keymap.set('n', '<leader>ql', function ()
    require('persistence').load { last = true }
end, { desc = '[Q]uick [L]oad' })
vim.keymap.set('n', '<leader>qd', function ()
    require('persistence').stop()
end, { desc = '[Q]uick [D]elete' })

vim.keymap.set('n', '<leader>lg', '<cmd>LazyGitCurrentFile<CR>', { desc = 'Open LazyGit' })
vim.diagnostic.config {
    underline = true,
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    severity_sort = true,
}
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function ()
        vim.highlight.on_yank()
    end,
})

vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '🟦', texthl = '', linehl = '', numhl = '' })
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then
        error('Error cloning lazy.nvim:\n' .. out)
    end
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup({

    'fladson/vim-kitty',
    'tpope/vim-sleuth',
    { 'numToStr/Comment.nvim',    opts = {} },
    {
        'lewis6991/gitsigns.nvim',
        config = function ()
            local gitsigns = require 'gitsigns'
            require('gitsigns').setup {
                signs = {
                    add = { text = '+' },
                    change = { text = '~' },
                    delete = { text = '_' },
                    topdelete = { text = '‾' },
                    changedelete = { text = '~' },
                },

                on_attach = function (bufnr)
                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end
                    map('n', ']c', function ()
                        if vim.wo.diff then
                            vim.cmd.normal { ']c', bang = true }
                        else
                            gitsigns.nav_hunk 'next'
                        end
                    end, { desc = 'Next git hunk' })

                    map('n', '[c', function ()
                        if vim.wo.diff then
                            vim.cmd.normal { '[c', bang = true }
                        else
                            gitsigns.nav_hunk 'prev'
                        end
                    end, { desc = 'Previous git hunk' })

                    map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'Stage git hunk' })
                    map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'Reset git hunk' })
                    map('v', '<leader>hs', function ()
                        gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
                    end, { desc = 'Stage git hunk from line to mark' })
                    map('v', '<leader>hr', function ()
                        gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
                    end, { desc = 'Reset git hunk from line to mark' })
                    map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'Stage git buffer' })
                    map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'Unstage git hunk' })
                    map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'Reset git buffer' })
                    map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'Preview git hunk' })
                    map('n', '<leader>hb', function ()
                        gitsigns.blame_line { full = true }
                    end, { desc = 'Blame git hunk' })
                    map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'Toggle git blame line' })
                    map('n', '<leader>hd', gitsigns.diffthis, { desc = 'Diff git hunk' })
                    map('n', '<leader>hD', function ()
                        gitsigns.diffthis '~'
                    end, { desc = 'Diff git hunk from last commit' })
                    map('n', '<leader>td', gitsigns.toggle_deleted, { desc = 'Toggle deleted git hunk' })
                end,
            }
        end,
    },

    {
        'folke/which-key.nvim',
        event = 'VimEnter',
        triggers = {
            { '<leader>', mode = { 'n', 'v' } },
        },

        config = function ()
            require('which-key').setup()
            require('which-key').add {
                { '<leader>b',  group = 'de[B]ugger' },
                { '<leader>b_', hidden = true },
                { '<leader>c',  group = '[C]ode' },
                { '<leader>c_', hidden = true },
                { '<leader>d',  group = '[D]ocument' },
                { '<leader>d_', hidden = true },
                { '<leader>h',  group = '[H]unks' },
                { '<leader>h_', hidden = true },
                { '<leader>r',  group = '[R]ename' },
                { '<leader>r_', hidden = true },
                { '<leader>s',  group = '[S]earch' },
                { '<leader>s_', hidden = true },
                { '<leader>t',  group = '[T]oggle' },
                { '<leader>t_', hidden = true },
                { '<leader>w',  group = '[W]orkspace' },
                { '<leader>w_', hidden = true },
            }
        end,
    },

    {
        'nvim-telescope/telescope.nvim',
        event = 'VimEnter',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',

                build = 'make',

                { 'nvim-tree/nvim-web-devicons',                 enabled = true },
                { 'nvim-telescope/telescope-live-grep-args.nvim' },
                { 'nvim-telescope/telescope-dap.nvim' },
            },
        },
        config = function ()
            vim.api.nvim_create_autocmd('FileType', { pattern = 'TelescopeResults', command = [[setlocal nofoldenable]] })
            require('telescope').setup {

                defaults = {
                    path_display = { 'smart' },
                },
                pickers = {
                    buffers = {
                        show_all_buffers = true,
                        sort_lastused = true,
                        mappings = {
                            i = {
                                ['<c-d>'] = 'delete_buffer',
                            },
                        },
                    },
                },
                extensions = {
                    ['ui-select'] = {
                        require('telescope.themes').get_dropdown(),
                    },
                },
            }

            pcall(require('telescope').load_extension, 'fzf')
            pcall(require('telescope').load_extension, 'ui-select')
            pcall(require('telescope').load_extension, 'live_grep_args')
            pcall(require('telescope').load_extension, 'dap')

            local builtin = require 'telescope.builtin'
            vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
            vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
            vim.keymap.set('n', '<leader>sfg', function ()
                builtin.find_files {
                    hidden = true,
                    no_ignore = true,
                    prompt_title = 'Find [F]iles [H]idden',
                }
            end, { desc = '[S]earch [F]iles [H]idden' })
            vim.keymap.set('n', '<leader>sf', function ()
                builtin.find_files {
                    hidden = true,
                }
            end, { desc = '[S]earch [F]iles' })
            vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
            vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
            vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
            vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
            vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
            vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
            vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
            vim.keymap.set('n', '<leader>sga', require('telescope').extensions.live_grep_args.live_grep_args,
                { desc = '[S]earch by [G]rep with [A]rgs' })

            vim.keymap.set('n', '<leader>/', function ()
                builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                    winblend = 10,
                    previewer = false,
                })
            end, { desc = '[/] Fuzzily search in current buffer' })

            vim.keymap.set('n', '<leader>s/', function ()
                builtin.live_grep {
                    grep_open_files = true,
                    prompt_title = 'Live Grep in Open Files',
                }
            end, { desc = '[S]earch [/] in Open Files' })

            vim.keymap.set('n', '<leader>sn', function ()
                builtin.find_files { cwd = vim.fn.stdpath 'config' }
            end, { desc = '[S]earch [N]eovim files' })
        end,
    },

    {
        'pmizio/typescript-tools.nvim',
        dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
        config = function ()
            require('typescript-tools').setup {
                on_attach = function (client)
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                end,
                handlers = {
                    ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
                        border = 'single',
                        focusable = false,
                    }),
                },
                settings = {
                    tsserver_max_memory = 4096,
                },
            }
        end,
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',
            'b0o/schemastore.nvim',
            { 'j-hui/fidget.nvim', opts = {} },

            {
                'folke/neodev.nvim',
                opts = {},
                config = function ()
                    require('neodev').setup {
                        library = { plugins = { 'nvim-dap-ui' }, types = true },
                    }
                end,
            },
        },
        config = function ()
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
                callback = function (event)
                    local map = function (keys, func, desc)
                        vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end

                    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
                    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
                    map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
                    map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
                    map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
                    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
                    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
                    map('K', vim.lsp.buf.hover, 'Hover Documentation')
                    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                    vim.keymap.set('i', '<C-]>', vim.lsp.buf.signature_help,
                        { buffer = event.buf, desc = 'Signature Help' })

                    local client = vim.lsp.get_client_by_id(event.data.client_id)

                    if client and client.server_capabilities.documentHighlightProvider then
                        -- vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                        --   buffer = event.buf,
                        --   callback = vim.lsp.buf.document_highlight,
                        -- })

                        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.clear_references,
                        })
                    end
                end,
            })

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

            local servers = {

                -- tsserver = {
                --   settings = {
                --     javascript = {
                --       format = {
                --         enable = false,
                --       },
                --     },
                --     typescript = {
                --       format = {
                --         enable = false,
                --       },
                --     },
                --   },
                -- },
                jsonls = {
                    settings = {
                        json = {
                            schemas = require('schemastore').json.schemas(),
                            validate = { enable = true },
                        },
                    },
                },

                lua_ls = {
                    settings = {
                        Lua = {
                            format = {
                                enable = true,
                            },
                            completion = {
                                callSnippet = 'Both',
                                displayContext = 3,
                                showWord = 'Enable',
                                keywordSnippet = 'Both',
                            },
                            -- diagnostics = { disable = { 'missing-fields' } },
                        },
                    },
                },
                marksman = {
                    settings = {
                        marksman = {},
                    },
                },
            }

            require('mason').setup()

            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {})
            require('mason-tool-installer').setup { ensure_installed = ensure_installed }

            require('mason-lspconfig').setup {
                handlers = {
                    function (server_name)
                        local server = servers[server_name] or {}

                        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                        require('lspconfig')[server_name].setup(server)
                    end,
                },
            }
        end,
    },

    {
        'stevearc/conform.nvim',
        opts = {
            notify_on_error = true,
            default_format_opts = {
                stop_after_first = true,
            },
            format_on_save = function (bufnr)
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                end
                return {
                    timeout_ms = 500,
                    lsp_fallback = true,
                }
            end,
            formatters_by_ft = {
                lua = { 'stylua' },
                javascript = { 'prettier' },
                typescript = { 'prettier' },
                javascriptreact = { 'prettier' },
            },
        },
    },

    { -- Autocompletion
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            {
                'L3MON4D3/LuaSnip',
                build = (function ()
                    -- Build Step is needed for regex support in snippets.
                    -- This step is not supported in many windows environments.
                    -- Remove the below condition to re-enable on windows.
                    if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
                        return
                    end
                    return 'make install_jsregexp'
                end)(),
            },
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
        },
        config = function ()
            -- See `:help cmp`
            local cmp = require 'cmp'
            local luasnip = require 'luasnip'
            luasnip.config.setup {}

            cmp.setup {
                snippet = {
                    expand = function (args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = { completeopt = 'menu,menuone,noinsert' },

                -- For an understanding of why these mappings were
                -- chosen, you will need to read `:help ins-completion`
                --
                -- No, but seriously. Please read `:help ins-completion`, it is really good!
                mapping = cmp.mapping.preset.insert {
                    -- Select the [n]ext item
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    -- Select the [p]revious item
                    ['<C-p>'] = cmp.mapping.select_prev_item(),

                    -- Scroll the documentation window [b]ack / [f]orward
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),

                    -- Accept ([y]es) the completion.
                    --  This will auto-import if your LSP supports it.
                    --  This will expand snippets if the LSP sent a snippet.
                    ['<C-y>'] = cmp.mapping.confirm { select = true },

                    -- If you prefer more traditional completion keymaps,
                    -- you can uncomment the following lines
                    --['<CR>'] = cmp.mapping.confirm { select = true },
                    --['<Tab>'] = cmp.mapping.select_next_item(),
                    --['<S-Tab>'] = cmp.mapping.select_prev_item(),

                    -- Manually trigger a completion from nvim-cmp.
                    --  Generally you don't need this, because nvim-cmp will display
                    --  completions whenever it has completion options available.
                    ['<C-Space>'] = cmp.mapping.complete {},

                    -- Think of <c-l> as moving to the right of your snippet expansion.
                    --  So if you have a snippet that's like:
                    --  function $name($args)
                    --    $body
                    --  end
                    --
                    -- <c-l> will move you to the right of each of the expansion locations.
                    -- <c-h> is similar, except moving you backwards.
                    ['<C-l>'] = cmp.mapping(function ()
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end, { 'i', 's' }),
                    ['<C-h>'] = cmp.mapping(function ()
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end, { 'i', 's' }),

                    -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
                    --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
                },
                sources = {
                    {
                        name = 'lazydev',
                        -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
                        group_index = 0,
                    },
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'path' },
                },
            }
        end,
    },
    {
        'rebelot/kanagawa.nvim',
        priority = 1000,
    },
    {

        'bluz71/vim-moonfly-colors',
        priority = 1000,
    },

    { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

    {
        'echasnovski/mini.nvim',
        config = function ()
            require('mini.ai').setup { n_lines = 500 }
            require('mini.surround').setup()
        end,
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function ()
            require('lualine').setup {
                options = {
                    theme = 'powerline_dark'
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch', 'diff', 'diagnostics' },
                    lualine_c = { { 'filename', path = 4 } },
                    lualine_x = { 'encoding', 'fileformat', 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' }
                },
                inactive_sections = {}
            }
        end
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        opts = {
            ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc' },
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = { 'ruby' },
            },
            indent = { enable = true, disable = { 'ruby' } },
        },

        config = function (_, opts)
            require('nvim-treesitter.configs').setup(opts)
        end,
    },
    -- {
    --     'mfussenegger/nvim-lint',
    --     event = { 'BufReadPre', 'BufNewFile' },
    --     config = function ()
    --         local lint = require 'lint'
    --         lint.linters_by_ft = {
    --             typescript = { 'eslint_d' },
    --             javascript = { 'eslint_d' },
    --         }
    --
    --         local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    --         vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
    --             group = lint_augroup,
    --             callback = function ()
    --                 lint.try_lint()
    --             end,
    --         })
    --     end,
    -- },
    {
        'mxsdev/nvim-dap-vscode-js',
        dependencies = { 'mfussenegger/nvim-dap' },
        config = function ()
            require('dap-vscode-js').setup {
                debugger_path = vim.fn.stdpath 'data' .. '/lazy/vscode-js-debug',
                adapters = { 'pwa-node' },
            }
        end,
    },
    {
        'mfussenegger/nvim-dap',
        config = function ()
            local dap = require 'dap'

            vim.keymap.set('n', '<leader>bc', dap.continue, { desc = 'Breakpoint [C]ontinue' })
            vim.keymap.set('n', '<leader>bb', dap.toggle_breakpoint, { desc = 'toggle [B]reakpoint' })
            vim.keymap.set('n', '<leader>bl', dap.list_breakpoints, { desc = 'list [B]reakpoints' })

            dap.configurations['javascript'] = {
                {
                    type = 'pwa-node',
                    request = 'attach',
                    name = 'Attach',
                    processId = require('dap.utils').pick_process,
                    cwd = '${workspaceFolder}',
                },
            }

            dap.configurations['typescript'] = {
                {
                    type = 'pwa-node',
                    request = 'attach',
                    name = 'Attach',
                    processId = require('dap.utils').pick_process,
                    cwd = '${workspaceFolder}',
                },
            }
        end,
    },
    {
        'rcarriga/nvim-dap-ui',
        dependencies = {
            'nvim-neotest/nvim-nio',
            'mfussenegger/nvim-dap',
        },
        config = function ()
            local dap, dapui = require 'dap', require 'dapui'
            dap.listeners.before.attach.dapui_config = function ()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function ()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function ()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function ()
                dapui.close()
            end

            vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })
            require('dapui').setup()
        end,
    },
    {
        'kdheepak/lazygit.nvim',
        cmd = {
            'LazyGit',
            'LazyGitConfig',
            'LazyGitCurrentFile',
            'LazyGitFilter',
            'LazyGitFilterCurrentFile',
        },

        dependencies = {
            'nvim-lua/plenary.nvim',
        },
    },
    {
        'folke/persistence.nvim',
        event = 'BufReadPre',
        config = true,
    },
}, {
    ui = {

        icons = vim.g.have_nerd_font and {} or {
            cmd = '⌘',
            config = '🛠',
            event = '📅',
            ft = '📂',
            init = '⚙',
            keys = '🗝',
            plugin = '🔌',
            runtime = '💻',
            require = '🌙',
            source = '📄',
            start = '🚀',
            task = '📌',
            lazy = '💤',
        },
    },
})

vim.cmd.colorscheme 'moonfly'
vim.cmd.hi 'Comment gui=none'

vim.api.nvim_create_user_command('FormatDisable', function (args)
    -- bang for buffer, otherwise globally disable the formatter
    if args.bang then
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
end, {
    desc = 'Disable Auto-Formatting on save',
    bang = true,
})

vim.api.nvim_create_user_command('FormatEnable', function (args)
    -- bang for buffer, otherwise globally disable the formatter
    if args.bang then
        vim.b.disable_autoformat = false
    else
        vim.g.disable_autoformat = false
    end
end, {
    desc = 'Disable Auto-Formatting on save',
    bang = true,
})
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>rn', ':lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })

local function extract_imports_from_content(filename, content)
    local file = io.open(filename, 'r')
    if not file then
        print('Error: cannot open file: ' .. filename)
        return nil
    end

    local imports_array = {}
    for line in file:lines() do
        if string.match(line, '^import') then
            table.insert(imports_array, line)
        end
    end
    return imports_array
end

local function overwrite_imports_to_file(filename, imports_array)
    -- remove all lines that match a particular pattern. in this case starting with import
    -- if pattern matches, then gsub that line to another line
    local file = io.open(filename, 'r')

    local contents = {}
    local imports_index = 1
    for line in file:lines() do
        if string.match(line, '^' .. imports_array[imports_index]) then
            line = imports_array[imports_index]
            contents[imports_index] = line
            imports_index = imports_index + 1
        end
    end
    file:close()

    file = io.open(filename, 'w')
    for _, line in ipairs(contents) do
        file:write(line .. '\n')
    end
    file:close()
end

local function append_js_extension(opts)
    local imports_array = extract_imports_from_content(opts.args) or {}
    for index, import_string in ipairs(imports_array) do
        import_string = string.sub(import_string, 1, -3) .. ".js';"
        print 'importing string \n'
        print(import_string)
        imports_array[index] = import_string
    end
    overwrite_imports_to_file(opts.args, imports_array)
end

vim.keymap.set('n', '<leader>ajs', append_js_extension, {})
