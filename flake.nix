{
  
  inputs = 
    { nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

      home-manager.url = "github:nix-community/home-manager/release-26.05"; 
      home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs: 
    { nixosConfigurations.laptop = nixpkgs.lib.nixosSystem 
      { system = "x86_64-linux";

      modules = 
      [ ./hosts/laptop/laptop.nix
	inputs.home-manager.nixosModules.home-manager
      ];

      specialArgs = { inherit inputs; };
      };
    };

}

