{ ... }:

{

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

}
