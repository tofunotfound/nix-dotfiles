{ config, pkgs, inputs, ... }:

{

  programs = 
  { fish.enable = true;  
    tmux.enable = true;

    #steam.enable = true;
    #steam.package = unstable.steam;
  };

  environment.systemPackages = with pkgs; 
  [ p7zip
    xclip
    less
    ookla-speedtest
    brightnessctl
    home-manager
  ];

  fonts.packages = with pkgs; 
  [ nerd-fonts.jetbrains-mono
  ];  

}
