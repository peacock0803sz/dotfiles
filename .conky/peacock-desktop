alignment top_left
gap_x 3120
gap_y 0

double_buffer yes
background yes

default_color ffffff
default_outline_color 666666
default_shade_color 666666

draw_borders no
draw_graph_borders yes
draw_outline no
draw_shades no

use_xft yes
xftfont Ubuntu:style=Regular:size=13

override_utf8_locale yes
out_to_console no
out_to_stderr no
extra_newline no

update_interval 0.3
uppercase no

show_graph_scale yes
show_graph_range no

own_window yes
own_window_class Conky
own_window_type normal
own_window_hints undecorated,below,skip_taskbar,skip_pager,sticky

own_window_transparent false
own_window_colour 000000
own_window_argb_visual true
own_window_argb_value 192

cpu_avg_samples 4

TEXT
${font Ubuntu:style=Bold:pixelsize=34}${time %m/%d %H:%M:%S}${font}
$hr
CPU1:${cpu cpu1}%${goto 125}CPU3:${cpu cpu3}%
${cpubar cpu1 4,118} ${cpubar cpu3 4,118}
CPU2:${cpu cpu2}%${goto 125}CPU4:${cpu cpu4}%
${cpubar cpu2 4,118} ${cpubar cpu4 4,118}
${cpugraph cpu0 50,}
RAM:${mem}/${memmax} ($memperc%)
${memgraph 50,}
Swap:${swap}/${swapmax} ($swapperc%)
$hr
Down:${downspeed enp0s31f6}${goto 125}Up:${upspeed enp0s31f6}
${downspeedgraph enp0s31f6 50,118 000000 ffffff} ${upspeedgraph enp0s31f6 50,118 000000 ffffff}
Uptime:$uptime
Processes:$processes