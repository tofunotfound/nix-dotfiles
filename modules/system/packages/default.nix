{ config, lib, pkgs, ... }:

let
  cfg = config.myModules.packages;
in

{
 
  options.myModules.default.enable = lib.mkEnableOption "default nix.settings";

  options.myModules.packages =
  { default.enable = lib.mkEnableOption "enable default pkgs";
    brightnessctl.enable = lib.mkEnableOption "enable brightnessctl";
    font.enable = lib.mkEnableOption "enable jetbrains font";
  };

  config = lib.mkMerge
  [ (lib.mkIf cfg.default.enable
    { environment.systemPackages = with pkgs; 
      [ neovim
        p7zip
        btop
      ];

      environment.variables.EDITOR = "nvim";
    })

    (lib.mkIf cfg.brightnessctl.enable
    { environment.systemPackages = [ pkgs.brightnessctl ];
    })

    (lib.mkIf cfg.font.enable
    { fonts.packages = with pkgs; 
      [ nerd-fonts.jetbrains-mono
      ];
    })

    (lib.mkIf config.myModules.default.enable
    { nix.settings =
      { max-jobs = "auto";
        cores = 0;
        http-connections = 50;
        download-buffer-size = 536870912;

        keep-outputs = true;
        keep-derivations = true;
        auto-optimise-store = true;

        trusted-users = [ "root" "@wheel" ];
        fallback = true;
        connect-timeout = 5;
        log-lines = 30;
        warn-dirty = false;
      };
    })

    { documentation.nixos.enable = false;
      environment.systemPackages = [ pkgs.home-manager ];
      nix.settings.experimental-features = [ "nix-command" "flakes" ];
      nixpkgs.config.allowUnfree = true;
    }
  ];

}
