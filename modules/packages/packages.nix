{ config, pkgs, inputs, ... }:

let
  unstable = import inputs.nixpkgs-unstable 
  { system = pkgs.system;
    config.allowUnfree = true;
  };
in 

{

  programs = 
  { fish.enable = true;
    tmux.enable = true;
    #steam.enable = true;
    #steam.package = unstable.steam;
  };

  environment.systemPackages = with pkgs; 
  [ git
    p7zip
    xclip
    less
    ookla-speedtest
    brightnessctl

    unstable.home-manager
  ];

  fonts.packages = with pkgs; 
  [ nerd-fonts.jetbrains-mono
  ];  

}
