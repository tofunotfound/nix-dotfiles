{
  
  inputs = 
    { nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

      home-manager.url = "github:nix-community/home-manager/master"; 
      home-manager.inputs.nixpkgs.follows = "nixpkgs";

      nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

      tele-client.url = "github:sorokin-vladimir/tele";
      catppuccin.url = "github:catppuccin/nix";
    };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, nixos-wsl, tele-client, catppuccin, ... }@inputs: 
    { nixosConfigurations = 
      { laptop = nixpkgs.lib.nixosSystem 
        { system = "x86_64-linux";
          
          specialArgs = { inherit inputs; };
                
          modules = 
          [ ./hosts/thinkpad 
            home-manager.nixosModules.home-manager
          ];  
        };


        wsl = nixpkgs.lib.nixosSystem 
        { system = "x86_64-linux";
          
  	  specialArgs = { inherit inputs; };
          
  	  modules = 
  	  [ ./hosts/wsl 
	    nixos-wsl.nixosModules.default
  	    home-manager.nixosModules.home-manager
  	  ];
        };
      };
    };

}

