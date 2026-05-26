{ ... }: {
  home.stateVersion = "26.05";
  nix.registry = {
    templates = {
      from = { type = "indirect"; id = "templa"; };
      to = { type = "github"; owner = "peacock0803sz"; repo = "templa"; };
    };
  };
}
