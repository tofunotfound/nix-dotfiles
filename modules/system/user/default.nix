{ config, pkgs, ... }:

{

  users.users.tofu = 
  { isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

}
