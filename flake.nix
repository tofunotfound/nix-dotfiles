{

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, nixos-wsl, tele-client, catppuccin, ... }@inputs:

    let
      commonModules =
      [ { _module.args = { inherit inputs; }; }

        home-manager.nixosModules.home-manager
        nixos-wsl.nixosModules.default
      ];
    in

    { nixosConfigurations =
      { laptop = nixpkgs.lib.nixosSystem
        { system = "x86_64-linux";
          modules = commonModules ++
          [ ./hosts/thinkpad
          ];
        };


        wsl = nixpkgs.lib.nixosSystem
        { system = "x86_64-linux";
          modules = commonModules ++
          [ ./hosts/wsl
          ];
        };
      };
    };

  inputs = 
    { nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

      home-manager.url = "github:nix-community/home-manager/master"; 
      home-manager.inputs.nixpkgs.follows = "nixpkgs";

      nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
      nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

      tele-client.url = "github:sorokin-vladimir/tele";
      catppuccin.url = "github:catppuccin/nix";
    };

}

