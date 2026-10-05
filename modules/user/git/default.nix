{ pkgs, ... }:

{

  programs.git = 
  { enable = true;
    package = pkgs.git;

    userName = "tofunotfound";
    userEmail = "tofunotfound@gmail.com";
  };

}
