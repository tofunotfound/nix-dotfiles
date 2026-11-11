{ config, lib, pkgs, ... }:

let
  cfg = config.myModules.packages;
in

{

  options.myModules.packages =
  { default.enable = lib.mkEnableOption "add default pkgs";
    brightnessctl.enable = lib.mkEnableOption "add brightnessctl";
    xclip.enable = lib.mkEnableOption "add xclip";
    font.enable = lib.mkEnableOption "add jetbrains font";
  };

  config = lib.mkMerge
  [ (lib.mkIf cfg.default.enable
    { environment.systemPackages = with pkgs; 
      [ neovim
        p7zip
        home-manager
      ];
  
      environment.variables.EDITOR = "nvim";
    })
    
    { environment.systemPackages = lib.filter lib.isDerivation (with pkgs;
      [ (if cfg.brightnessctl.enable then brightnessctl else null)
        (if cfg.xclip.enable then xclip else null)
      ]);
    }

    (lib.mkIf cfg.font.enable
    { fonts.packages = with pkgs; 
      [ nerd-fonts.jetbrains-mono
      ];
    })

    { documentation.nixos.enable = false;
    }
  ];

}
