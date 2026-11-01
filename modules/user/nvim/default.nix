{
 pkgs, ... }:

{

  programs.neovim = 
  { enable = true;

    plugins = with pkgs.vimPlugins; 
    [ obsidian-nvim
      telescope-nvim
      nvim-cmp
      render-markdown-nvim
      nvim-treesitter.withAllGrammars
      cmp-buffer
      cmp-path
    ];

    extraLuaConfig = ''
       require("obsidian").setup({

         legacy_commands = false,

	 frontmatter = {
	   enabled = false,
	 },

         workspaces = {
	  {
	    name = "vault",
	    path = "~/Sync/Notes",
	  },
         },

	 daily_notes = {
	   folder = "dailies",
	   date_format = "YYYY-MM-DD",
	   template = "template-daily.md",
	 },

	 templates = {
	   folder = "templates",
	   date_format = "YYYY-MM-DD",
	   time_format = "HH:MM",
	 },
       })

       vim.opt.conceallevel = 2
    '';
  };

}
