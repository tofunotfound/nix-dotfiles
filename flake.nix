{
  
  inputs = 
    { nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

      home-manager.url = "github:nix-community/home-manager/master"; 
      home-manager.inputs.nixpkgs.follows = "nixpkgs";

      tele-client.url = "github:sorokin-vladimir/tele";
    };

  outputs = { self, nixpkgs, nixpkgs-stable, tele-client, ... }@inputs: 
    { nixosConfigurations.laptop = nixpkgs.lib.nixosSystem 
      { system = "x86_64-linux";

      modules = 
      [ ./hosts/thinkpad
	inputs.home-manager.nixosModules.home-manager
      ];

      specialArgs = { inherit inputs; };
      };
    };

}

