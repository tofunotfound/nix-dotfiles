{ pkgs, ... }:

{

  programs = 
  { fish.enable = true;  
    tmux.enable = true;

    steam.enable = true;
  };

  environment.systemPackages = with pkgs; 
  [ neovim
      ripgrep
      fd
    p7zip
    xclip
    brightnessctl
    home-manager
  ];

  environment.variables.EDITOR = "nvim";

  fonts.packages = with pkgs; 
  [ nerd-fonts.jetbrains-mono
  ];  

}
