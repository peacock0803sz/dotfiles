{ ... }@args: {
  imports = [ args.vibra.nixosModules.vibra ];

  services.vibra = {
    enable = true;
    backend = {
      allowedDirs = [ "/home/${args.username}/src" ];
      devUser = args.username;
      defaultWorkdir = "/home/${args.username}/src";
      environmentFile = "/var/lib/vibra/env";
    };
    frontend.enable = true;
  };
}
