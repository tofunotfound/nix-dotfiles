{ ... }:

{

  imports =
  [ ./configuration.nix
    ./hardware-configuration.nix
    ../../modules/system/features
    ../../modules/system/i3
    ../../modules/system/packages
    ../../modules/system/pipewire
    ../../modules/system/syncthing
    ../../modules/system/unclutter
    ../../modules/user/user
  ];
  
  myFeatures = 
  { network = true;
    fstrim = true;
    openssh = true;
  
    xserverI3 = true;  
    pipewire = true;   
    syncthing = true;
    unclutter = true;
  };

}


