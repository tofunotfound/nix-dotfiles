{ ... }:

{

  imports =
  [ ./configuration.nix
    ./hardware-configuration.nix
    ../../modules/packages/packages.nix
    ../../modules/services
    ../../modules/users/tofu.nix
  ];

  myFeatures.network = true;
  myFeatures.fstrim = true;
  myFeatures.openssh = true;
  
  myFeatures.xserverI3 = true;  
  myFeatures.pipewire = true;   
  myFeatures.syncthing = true;
  myFeatures.unclutter = true;

}


