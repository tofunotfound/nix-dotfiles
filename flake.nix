{
  
  inputs = 
    { nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

      home-manager.url = "github:nix-community/home-manager/master"; 
      home-manager.inputs.nixpkgs.follows = "nixpkgs";

      tele-client.url = "github:sorokin-vladimir/tele";
      catppuccin.url = "github:catppuccin/nix";
    };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, tele-client, catppuccin, ... }@inputs: 
    { nixosConfigurations.laptop = nixpkgs.lib.nixosSystem 
      { system = "x86_64-linux";
        
	specialArgs = { inherit inputs; };
        
	modules = 
	[ ./hosts/thinkpad 
	  home-manager.nixosModules.home-manager
	];

      };
    };

}

