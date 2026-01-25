{ ... }@inputs: {
  imports = [
    ./large.nix
  ];

  home.packages = with inputs.pkgs; [
    sqlite
    kubectl
    terraform

    act
    awscli2
    cloudflared
  ];
}
