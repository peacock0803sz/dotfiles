{ pkgs, config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  services.ssh-agent.enable = true;

  systemd.user.services.ssh-add = {
    Unit = {
      Description = "Add SSH keys to ssh-agent";
      After = [ "ssh-agent.service" ];
      Requires = [ "ssh-agent.service" ];
      ConditionPathExists = "%h/.ssh/id_ed25519";
    };
    Service = {
      Type = "oneshot";
      Environment = "SSH_AUTH_SOCK=%t/${config.services.ssh-agent.socket}";
      ExecStart = "${config.services.ssh-agent.package}/bin/ssh-add %h/.ssh/id_ed25519";
    };
    Install.WantedBy = [ "default.target" ];
  };

  home.file = {
    ".gitconfig".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/dot_config/git/.gitconfig.nixos";
  };
}
