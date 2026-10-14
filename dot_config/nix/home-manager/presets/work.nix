{ pkgs, ... }: 
let
  gx-nur = (builtins.getFlake "git+ssh://git@github.com/groove-x/gx-nur").packages.${pkgs.stdenv.hostPlatform.system};
in
{
  home.packages = with pkgs; [
    nur.repos.peacock0803sz.aqua
    nur.repos.peacock0803sz.tccli
    gx-nur.gxcloud-cli
    gx-nur.lovot-tools

    yarn
    lefthook

    grpcurl
    keto
    kratos
    ory
  ];
}
