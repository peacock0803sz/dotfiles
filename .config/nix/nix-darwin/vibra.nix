{ ... }@args: {
  imports = [ args.inputs.vibra.darwinModules.vibra ];

  services.vibra = {
    enable = true;
    backend = {
      allowedDirs = [ "/Users/${args.username}/src" ];
      devUser = args.username;
      defaultWorkdir = "/Users/${args.username}/src";
    };
    frontend.enable = false;
  };
}
