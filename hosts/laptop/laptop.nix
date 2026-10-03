{ ... }:

{

  imports =
  [ ./configuration.nix
    ./hardware-configuration.nix
    ../../modules/packages/packages.nix
    ../../modules/services
    ../../modules/users/tofu.nix
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


