{ ... }:

{

  xdg.configFile."i3blocks/blocklets/time" = 
  { executable = true;

    text = ''
       #!/usr/bin/env bash

       date '+%d-%m-%Y %H:%M:%S'      
    '';
  };

}
