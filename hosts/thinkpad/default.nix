{ config, pkgs, inputs, ... }:

{

  imports =
  [ ./configuration.nix
    ./hardware-configuration.nix
    ../../modules/system
  ];

  home-manager.extraSpecialArgs = { inherit inputs; };
  home-manager.users.tofu = { config, pkgs, ... }:
  { home.username = "tofu";
    home.homeDirectory = "/home/tofu";
    home.stateVersion = "26.05";
     
    imports = 
    [ ./home.nix
      ../../modules/user
    ];
   };

}


