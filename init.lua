--THEME
vim.cmd([[set termguicolors]])
vim.o.background=dark
vim.cmd([[set number]])
-- 4 SPACE TAB
vim.cmd([[set tabstop=4]])
vim.cmd([[set shiftwidth=4]])
vim.cmd([[set softtabstop=4]])
vim.cmd([[set expandtab]])
--OPT MODE
vim.cmd [[packadd packer.nvim]]
--MOUSE SCROLL
vim.cmd([[set mouse=a]])
--KEY MAPS
vim.cmd([[nmap <silent> <c-s>     :w<CR>]])
vim.cmd([[nmap <silent> <c-Right> :bnext<CR>]])
vim.cmd([[nmap <silent> <c-Left>  :bprev<CR>]])
vim.cmd([[nmap <silent> <c-n>     :NeoTreeFocusToggle<CR>]])
--LINE NUMBERS
vim.cmd([[set relativenumber]])
--PLUGINS
return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    --LUALINE
    use {
    	'nvim-lualine/lualine.nvim',
    	requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    require('lualine').setup({
        options = {
            theme = 'auto'
        }
    }) 
    
    --INDENT LINES
    require("packer").startup(function()
        use "lukas-reineke/indent-blankline.nvim"
    end)
    
    --THEMES
	use {
        'ellisonleao/gruvbox.nvim',
    }
    require("gruvbox").setup({
		undercurl = false,
		underline = false,
		bold = true,
		italic = false
	})
	vim.cmd([[colorscheme gruber]])
    
    use {
        'shaunsingh/nyoom.nvim'
    }
    --NEO TREE
	use {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.42",
        requires = { 
            "nvim-lua/plenary.nvim",
            "kyazdani42/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        }
    }
    
    -- AUTO PAIRS
    use {
	    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
    }
    
    -- SYNTAX HIGHLIGHTING
    use 'nvim-treesitter/nvim-treesitter'
    require'nvim-treesitter.configs'.setup {
        ensure_installed = { "c", "cpp", "lua", "rust", "python" },
        sync_install = false,
        auto_install = true,
        ignore_install = { "javascript" },
        highlight = {
            enable = true,
            disable = { "c", "rust" },
            disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,
        additional_vim_regex_highlighting = true,
        },
    }

    --BUFFERLINE ON TOP
    use {'akinsho/bufferline.nvim', tag = "v3.*", requires = 'kyazdani42/nvim-web-devicons'}
    require("bufferline").setup{}

    --AUTOCOMPLETE
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'

    local cmp = require'cmp'

    cmp.setup({
        snippet = {
            -- REQUIRED - you must specify a snippet engine
            expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            end,
        },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered()
        },
        mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
            --['<Right>'] = cmp.mapping.confirm({ select = true }),
            ['<TAB>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'vsnip' }, -- For vsnip users.
            }, {
              { name = 'buffer' },
            })
        })
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        local lspconfig = require'lspconfig'
        
        lspconfig.clangd.setup {
            capabilities = capabilities
        }
	lspconfig.rust_analyzer.setup {
	    on_attach=on_attach,
	    settings = {
		["rust-analyzer"] = {
		    imports = {
			granularity = {
			    group = "module",
			},
			prefix = "self",
		    },
		    cargo = {
			buildScripts = {
			    enable = true,
			},
		    },
		    procMacro = {
			enable = true
		    },
		}
	    }
	}
        lspconfig.pyright.setup {
            capabilities = capabilities
        }
        --
        --lspconfig.ccls.setup {
        --    capabilities = capabilities,
        --    init_options = {
        --        compilationDatabaseDirectory = "build";
        --        index = {
        --            threads = 0;
        --        };
        --        clang = {
        --            excludeArgs = { "-frounding-math"} ;
        --        };
        --    }
        -- }
    --TELESCOPE
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} }
    }
end)



