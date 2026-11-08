{ pkgs, inputs, ... }:

{

  home.packages = with pkgs;
  [ yazi
    maim
    playerctl
    mpv
    btop
    firefox
    opencode
    warpd
    inputs.tele-client.packages.${pkgs.system}.default
   ];

}
