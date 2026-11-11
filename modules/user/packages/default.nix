{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.myHomeModules.packages;
in

{

  options.myHomeModules.packages = 
  { default.enable = lib.mkEnableOption "enable default packages";
    playerctl.enable = lib.mkEnableOption "enable playerctl";
    mpv.enable = lib.mkEnableOption "enable mpv";
    maim.enable = lib.mkEnableOption "enable maim";
    warpd.enable = lib.mkEnableOption "enable warpd";
    opencode.enable = lib.mkEnableOption "enable opencode";
    tele.enable = lib.mkEnableOption "enable tg cli";
  };

  config = lib.mkMerge
  [ (lib.mkIf cfg.default.enable
    { home.packages = with pkgs;
      [ yazi
        btop
      ];
    })

    { home.packages = lib.filter lib.isDerivation (with pkgs;
      [ (if cfg.playerctl.enable then playerctl else null)
        (if cfg.mpv.enable then mpv else null)
        (if cfg.maim.enable then maim else null)
        (if cfg.warpd.enable then warpd else null)
        (if cfg.opencode.enable then opencode else null)
        (if cfg.tele.enable then inputs.tele-client.packages.${pkgs.system}.default else null)
      ]);
    }
  ];

}
