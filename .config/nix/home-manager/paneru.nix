# home.nix
{ paneru, ... }:

{
  imports = [
    paneru.homeModules.paneru
  ];

  services.paneru = {
    enable = false;
    # Equivalent to what you would put into `~/.paneru` (See Configuration options below).
    settings = {
      options = {
        focus_follows_mouse = true;
        preset_column_widths = [
          0.25
          0.33
          0.5
          0.66
          0.75
        ];
        swipe_gesture_fingers = 4;
        animation_speed = 4000;
      };
      bindings = {
        window_focus_west = "cmd - h";
        window_focus_east = "cmd - l";
        window_focus_north = "cmd - k";
        window_focus_south = "cmd - j";
        window_swap_west = "cmd + ctrl - h";
        window_swap_east = "cmd + ctrl - l";
        window_swap_first = "ctrl + shift - h";
        window_swap_last = "ctrl + shift - l";
        window_center = "cmd + ctrl - Enter";
        window_resize = "cmd + ctrl - tab";
        window_manage = "cmd + ctrl - t";
        window_stack = "cmd + ctrl - s";
        window_unstack = "cmd + ctrl + shift - s";
        quit = "cmd + ctrl - q";
      };
    };
  };
}
