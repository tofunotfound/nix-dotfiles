{ ... }:

{

  xdg.configFile."i3blocks/blocklets/memory" = 
  { executable = true;

    text = ''
       #!/usr/bin/env bash

       free -h | awk '/^Mem:/ {print " " $3 " / " $2}'
    '';
  };

}
