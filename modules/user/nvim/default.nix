{ pkgs, ... }:

{
  
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
    ];

    extraLuaConfig = 
    '' vim.opt.conceallevel = 2

       vim.api.nvim_create_autocmd('FileType', {
         pattern = { 'markdown', 'lua' },
	 callback = function() end,
       })

       require('render-markdown').setup({})
       require('nvim-web-devicons').setup({})

       require('blink.cmp').setup({
         keymap = { preset = 'default' },
	 sources = {
	   default = { 'path', 'lsp' },
	 },
       })
       
       require('zk').setup({
         picker = "telescope",
         lsp = {
           config = {
             cmd = { "zk", "lsp" },
             name = "zk",
             on_attach = function(client, bufnr)
               vim.keymap.set("n", "gf", vim.lsp.buf.definition, { buffer = bufnr, silent = true })
             end,
           },
           auto_attach = {
             enabled = true,
           },
         },
       })  

       local note_actions = {
         today = function() require("zk").new({ group = "daily" }) end,
         tomorrow = function() require("zk").new({ group = "daily", date = "tomorrow" }) end,
         weekly = function() require("zk").new({ group = "weekly" }) end,
       }

       vim.api.nvim_create_user_command("Note", function(opts)
         local action = note_actions[opts.args]
         if action then
           action()
         else
           vim.notify("Unknown argument: " .. opts.args, vim.log.levels.ERROR)
         end
       end, {
         nargs = 1,
         complete = function()
           return { "today", "tomorrow", "weekly" }
         end,
       })
    '';
  };

}
