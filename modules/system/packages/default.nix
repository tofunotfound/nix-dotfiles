{ pkgs, ... }:

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
    brightnessctl
    home-manager
  ];

  fonts.packages = with pkgs; 
  [ nerd-fonts.jetbrains-mono
  ];  

}
