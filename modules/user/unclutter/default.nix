{ pkgs, ... }:

{

  services.unclutter = 
  { enable = true;
    package = pkgs.unclutter-xfixes;
    timeout = 1;
    extraOptions = [ "root" ];
  };

}
