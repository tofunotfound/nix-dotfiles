{ lib, pkgs, inputs, ... }:

{

  imports =
  [ inputs.catppuccin.homeManagerModules.catppuccin
  ];

  catppuccin = 
  { enable = true;
    flavor = "mocha";
    accent = "mauve";
  };

}
