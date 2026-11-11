{ config, lib, ... }:

let
  cfg = config.myModules.git;
in

{
 
  options.myModules.git.enable = lib.mkEnableOption "enable git";

  config = lib.mkIf cfg.enable {
    programs.git = 
    { enable = true;

      config = 
      { user = 
        { name = "tofunotfound";
          email = "tofunotfound@gmail.com";
        };
        init.defaultBranch = "main";
      };
    };
  };

}
