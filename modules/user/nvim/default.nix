{ config, lib, pkgs, ... }:

let
  cfg = config.myHomeModules.nvim;
in

{

  options.myHomeModules.nvim.enable = lib.mkEnableOption "nvim settings";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
    [ ripgrep
      fd
      zk
    ];

    programs.neovim =
    { enable = true;

      plugins = with pkgs.vimPlugins;
      [ telescope-nvim
        render-markdown-nvim
        nvim-web-devicons
        blink-cmp
        zk-nvim
        langmapper-nvim
        bullets-vim
        indent-blankline-nvim
      ];

      extraLuaConfig =
      ''vim.opt.linebreak = true

        vim.opt.number = true
        vim.opt.relativenumber = true

        vim.opt.list = true

        vim.opt.expandtab = true
        vim.opt.shiftwidth = 2
        vim.opt.tabstop = 2
        vim.opt.softtabstop = 2

        local langmapper = require('langmapper')
        langmapper.setup({
        hack_keymap = true,
        })

        require("ibl").setup({
          indent = { char = "|" },
        })

        local shortcuts = {
        ['й'] = 'q', ['ц'] = 'w', ['цй'] = 'wq', ['я'] = 'q!',
        }
        for ru, en in pairs(shortcuts) do
        vim.cmd(string.format('cabbrev %s %s', ru, en))
        end

        local zk = require("zk")
        zk.setup({
          picker = "telescope",
          lsp = {
            config = {
              on_attach = function(client, bufnr)
              vim.keymap.set("n", "gf", vim.lsp.buf.definition, { buffer = bufnr })
            end,
            },
          },
        })

        local zk_commands = {
          ZkToday    = { group = "daily" },
          ZkTomorrow = { group = "daily", date = "tomorrow" },
          ZkWeek     = { group = "weekly" },
        }

        for cmd_name, config in pairs(zk_commands) do
          vim.api.nvim_create_user_command(cmd_name, function()
            require("zk").new(config)
          end, {})
        end

        require('blink.cmp').setup({
          sources = {
            default = { 'lsp', 'path' },
          },
          keymap = { preset = 'default' },
        })

        require("telescope").setup({})
        require("render-markdown").setup({})
      '';
    };
  };

}
