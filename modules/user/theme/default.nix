{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.myHomeModules.theme.catppuccin;
in

{

  imports =
  [ inputs.catppuccin.homeManagerModules.catppuccin
  ];

  options.myHomeModules.theme.catppuccin.enable = lib.mkEnableOption "enable theme";

  config = lib.mkIf cfg.enable
  { catppuccin =
    { enable = true;
      flavor = "mocha";
      accent = "mauve";
    };
  };

}
