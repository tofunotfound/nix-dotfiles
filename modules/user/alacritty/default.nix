{ config, lib, ... }:

let
  cfg = config.myHomeModules.alacritty;
in

{

  options.myHomeModules.alacritty.enable = lib.mkEnableOption "enable alacritty";

  config = lib.mkIf cfg.enable {
    programs.alacritty =
    { enable = true;

      settings =
      { window =
        { dynamic_padding = true;
          padding =
          { x = 3;
          };
        };

        font =
        { size = 10.0;

          offset =
          { x = 0;
            y = -2;
          };

          normal =
          { family = "JetBrainsMono Nerd Font";
            style = "Regular";
          };
          bold =
          { family = "JetBrainsMono Nerd Font";
          style = "Bold";
          };
          italic =
          { family = "JetBrainsMono Nerd Font";
          style = "Italic";
          };
          bold_italic =
          { family = "JetBrainsMono Nerd Font";
          style = "Bold Italic";
          };
        };
      };
    };
  };
}
