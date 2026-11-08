{ config, lib, ... }:

let
  cfg = config.myHomeModules.gtk-3;
in

{

  options.myHomeModules.gtk-3.enable = lib.mkEnableOption "add gtk-3.0";

  config = lib.mkIf cfg.enable {
    xdg.configFile."gtk-3.0/settings.ini".text = 
    ''[Settings]
      gtk-theme-name = Adwaita
      gtk-application-prefer-dark-theme = true
    '';
  };

}
