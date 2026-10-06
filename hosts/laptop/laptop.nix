{ ... }:

{

  imports =
  [ ./configuration.nix
    ./hardware-configuration.nix
    ../../modules/system/features
    ../../modules/system/i3
    ../../modules/system/packages
    ../../modules/system/pipewire
    ../../modules/system/nvim
    ../../modules/system/git
    ../../modules/user/user
  ];

}


