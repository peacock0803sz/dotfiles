{ ... }@args: {
  imports = [ args.vibra.nixosModules.vibra ];

  services.vibra = {
    enable = true;
    backend = {
      listenAddr = "0.0.0.0:3001";
      corsOrigin = "http://enigma.tail2121a.ts.net:3000";
      allowedDirs = [ "/home/${args.username}/src" ];
      defaultWorkdir = "/home/${args.username}/src";
      environmentFile = "/var/lib/vibra/env";
    };
    frontend.enable = true;
  };
}
