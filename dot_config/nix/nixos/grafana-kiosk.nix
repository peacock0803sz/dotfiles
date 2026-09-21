# サイネージ用のホスト別ダッシュボードを prometheus-targets.nix から生成する。
# ホストを1件足せば収集とダッシュボードとプレイリスト入りが同時に揃うので、
# 追加時に片方だけ忘れて画面から漏れる、という事故が起きない。
{ pkgs, lib, ... }:
let
  targets = import ./prometheus-targets.nix;

  # プレイリストはこのタグで対象を集める。タグさえ合っていれば
  # ダッシュボードが増えても巡回定義を触る必要がない
  tag = "kiosk-host";

  ds = { type = "prometheus"; uid = "prometheus"; };

  tgt = expr: legend: refId: {
    datasource = ds;
    editorMode = "code";
    inherit expr refId;
    legendFormat = legend;
    range = true;
  };

  pctSteps = [
    { color = "green"; value = null; }
    { color = "yellow"; value = 70; }
    { color = "red"; value = 85; }
  ];
  tempSteps = [
    { color = "green"; value = null; }
    { color = "yellow"; value = 65; }
    { color = "red"; value = 80; }
  ];
  plainSteps = [{ color = "green"; value = null; }];

  # 縦置き (1080x1920 相当) 用に w=24 フル幅で縦積みする。横並びを残すと
  # ポートレートでは1パネルが細長くなり読めないため。y は上から累積
  # (stat 2段=8 + 時系列 9×4段)。1920px の縦解像度に収まる想定
  statBase = { id, title, x, y, w, steps }: {
    inherit id title;
    type = "stat";
    datasource = ds;
    gridPos = { h = 4; inherit w x y; };
    fieldConfig = {
      defaults = {
        mappings = [ ];
        color.mode = "thresholds";
        thresholds = { mode = "absolute"; steps = steps; };
      };
      overrides = [ ];
    };
    options = {
      justifyMode = "auto";
      wideLayout = true;
      percentChangeColorMode = "standard";
      showPercentChange = false;
      reduceOptions = { calcs = [ "lastNotNull" ]; fields = ""; values = false; };
    };
  };

  # しきい値で色が付く数値系。色が出たら見る、という約束を DISK と TEMP に集約する
  statNum = { id, title, x, y, w, unit, steps, targets }:
    let b = statBase { inherit id title x y w steps; }; in
    b // {
      fieldConfig = b.fieldConfig // {
        defaults = b.fieldConfig.defaults // { inherit unit; decimals = 0; min = 0; };
      };
      options = b.options // {
        colorMode = "value";
        graphMode = "area";
        orientation = "vertical";
        textMode = "auto";
      };
      inherit targets;
    };

  # 値ではなく系列名 (pretty_name) を出す
  statText = { id, title, x, y, w, targets }:
    let b = statBase { inherit id title x y w; steps = plainSteps; }; in
    b // {
      options = b.options // {
        colorMode = "background";
        graphMode = "none";
        orientation = "auto";
        textMode = "name";
      };
      inherit targets;
    };

  # 横向き棒グラフ。/ と /mnt/* の複数マウントを並べて出す DISK 用。
  # stat だと値が重なって読めないので bargauge horizontal にする
  barGauge = { id, title, x, y, w, unit, steps, targets }: {
    inherit id title targets;
    type = "bargauge";
    datasource = ds;
    gridPos = { h = 4; inherit w x y; };
    fieldConfig = {
      defaults = {
        inherit unit;
        mappings = [ ];
        min = 0;
        max = 100;
        color.mode = "thresholds";
        thresholds = { mode = "absolute"; steps = steps; };
      };
      overrides = [ ];
    };
    options = {
      displayMode = "gradient";
      legend = { calcs = [ ]; displayMode = "list"; placement = "bottom"; showLegend = false; };
      maxVizHeight = 300;
      minVizHeight = 16;
      minVizWidth = 8;
      namePlacement = "auto";
      orientation = "horizontal";
      reduceOptions = { calcs = [ "lastNotNull" ]; fields = ""; values = false; };
      showUnfilled = true;
      sizing = "auto";
      valueMode = "color";
    };
  };

  # 稼働時間用。dtdurations は decimals が成分数になる (0=日のみ、2=日・時・分)。
  # 常に分まで出すため decimals = 2 にする
  statDur = { id, title, x, y, w, targets }:
    let b = statBase { inherit id title x y w; steps = plainSteps; }; in
    b // {
      fieldConfig = b.fieldConfig // {
        defaults = b.fieldConfig.defaults // { unit = "dtdurations"; decimals = 2; };
      };
      options = b.options // {
        colorMode = "none";
        graphMode = "area";
        orientation = "horizontal";
        textMode = "value";
      };
      inherit targets;
    };

  ts = { id, title, x, y, w, unit, min ? 0, max ? null, targets, overrides ? [ ] }: {
    inherit id title;
    type = "timeseries";
    datasource = ds;
    gridPos = { h = 9; inherit w x y; };
    fieldConfig = {
      defaults = {
        inherit unit;
        color.mode = "palette-classic";
        custom = {
          drawStyle = "line";
          lineWidth = 2;
          fillOpacity = 15;
          gradientMode = "opacity";
          showPoints = "never";
          pointSize = 5;
          spanNulls = true;
          axisPlacement = "auto";
          axisLabel = "";
          axisBorderShow = false;
          axisCenteredZero = false;
          axisColorMode = "text";
          barAlignment = 0;
          lineInterpolation = "linear";
          scaleDistribution.type = "linear";
          stacking = { group = "A"; mode = "none"; };
          thresholdsStyle.mode = "off";
          hideFrom = { legend = false; tooltip = false; viz = false; };
          insertNulls = false;
        };
        thresholds = { mode = "absolute"; steps = plainSteps; };
      } // lib.optionalAttrs (min != null) { inherit min; }
      // lib.optionalAttrs (max != null) { inherit max; };
      inherit overrides;
    };
    options = {
      legend = { displayMode = "list"; placement = "bottom"; showLegend = true; calcs = [ ]; };
      tooltip = { mode = "multi"; sort = "desc"; hideZeros = false; };
    };
    inherit targets;
  };

  mkPanels = host: spec:
    let
      hasGpu = spec.ports or { } ? nvidia;
    in
    [
      (statText {
        id = 1;
        title = "Hostname";
        x = 0;
        y = 0;
        w = 12;
        targets = [ (tgt ''group by(instance) (node_uname_info{instance="${host}"})'' "__auto" "A") ];
      })
      (statText {
        id = 2;
        title = "OS";
        x = 12;
        y = 0;
        w = 12;
        targets = [ (tgt ''group by(pretty_name) (node_os_info{instance="${host}"})'' "__auto" "A") ];
      })
      (statDur {
        // Uptime は期間文字列が長いので幅を広めに取る。狭いままだと
        // 自動縮小で文字が読めなくなる
        id = 3;
        title = "Uptime";
        x = 0;
        y = 4;
        w = 16;
        targets = [ (tgt ''time() - node_boot_time_seconds{instance="${host}"}'' "__auto" "A") ];
      })
      # / と /nix/store は同一デバイスなので / だけに絞る。Samba 用のような
      # 追加マウントは増えたぶんだけ値が並ぶ。埋まったら気付きたいのであえて出す
      (barGauge {
        id = 4;
        title = "Disk";
        x = 0;
        y = 8;
        w = 24;
        unit = "percent";
        steps = pctSteps;
        targets = [ (tgt ''100 - (node_filesystem_avail_bytes{instance="${host}",mountpoint=~"/|/mnt/.*",fstype!~"tmpfs|ramfs"} / node_filesystem_size_bytes{instance="${host}",mountpoint=~"/|/mnt/.*",fstype!~"tmpfs|ramfs"} * 100)'' "{{mountpoint}}" "A") ];
      })
      (statNum {
        id = 5;
        title = "Temperature";
        x = 16;
        y = 4;
        w = 8;
        unit = "celsius";
        steps = tempSteps;
        targets = [ (tgt ''max by(instance) (node_hwmon_temp_celsius{instance="${host}",chip="platform_coretemp_0"})'' "TEMP" "A") ];
      })
      (ts {
        id = 6;
        title = "CPU%";
        x = 0;
        y = 12;
        w = 24;
        unit = "percent";
        max = 100;
        targets = [ (tgt ''100 - (avg by(instance, cpu) (rate(node_cpu_seconds_total{mode="idle",instance="${host}"}[2m])) * 100)'' "CPU {{cpu}}" "A") ];
      })
      (ts {
        id = 7;
        title = "Memory";
        x = 0;
        y = 21;
        w = 24;
        unit = "bytes";
        targets = [
          (tgt ''node_memory_MemTotal_bytes{instance="${host}"} - node_memory_MemAvailable_bytes{instance="${host}"}'' "Used" "A")
          (tgt ''node_memory_MemTotal_bytes{instance="${host}"}'' "Total" "B")
        ];
        overrides = [{
          matcher = { id = "byName"; options = "Total"; };
          properties = [
            { id = "custom.fillOpacity"; value = 0; }
            { id = "custom.lineStyle"; value = { fill = "dash"; dash = [ 8 8 ]; }; }
            { id = "color"; value = { mode = "fixed"; fixedColor = "text"; }; }
          ];
        }];
      })
      # ベースデバイスだけに絞る。パーティション (sda1 等) や loop を出すと読めない。
      # write を負値で描いて read と上下に分けるので、ここだけ min を外す
      (ts {
        id = 10;
        title = "Disk I/O";
        x = 0;
        y = 30;
        w = 24;
        unit = "Bps";
        min = null;
        targets = [
          (tgt ''rate(node_disk_read_bytes_total{instance="${host}",device=~"sd[a-z]+|nvme[0-9]+n[0-9]+|vd[a-z]+|hd[a-z]+|mmcblk[0-9]+"}[2m])'' "{{device}} read" "A")
          (tgt ''-rate(node_disk_written_bytes_total{instance="${host}",device=~"sd[a-z]+|nvme[0-9]+n[0-9]+|vd[a-z]+|hd[a-z]+|mmcblk[0-9]+"}[2m])'' "{{device}} write" "B")
        ];
      })
      # 物理 NIC だけに絞る。VPN の tun0 やブリッジを出しても読めない。
      # tx を負値で描いて rx と上下に分けるので、ここだけ min を外す
      (ts {
        id = 8;
        title = "Network I/O";
        x = 0;
        y = 39;
        w = 24;
        unit = "Bps";
        min = null;
        targets = [
          (tgt ''rate(node_network_receive_bytes_total{instance="${host}",device=~"en.*|wl.*"}[2m])'' "{{device}} rx" "A")
          (tgt ''-rate(node_network_transmit_bytes_total{instance="${host}",device=~"en.*|wl.*"}[2m])'' "{{device}} tx" "B")
        ];
      })
    ]
    # nvidia exporter を持つホストだけ GPU 段を足す。prometheus-targets.nix の
    # ports に nvidia があるかどうかだけで決まる
    ++ lib.optional hasGpu (ts {
      id = 9;
      title = "GPU";
      x = 0;
      y = 48;
      w = 24;
      unit = "percent";
      max = 100;
      targets = [
        (tgt ''nvidia_smi_utilization_gpu_ratio{instance="${host}"} * 100'' "GPU util" "A")
        (tgt ''nvidia_smi_memory_used_bytes{instance="${host}"} / nvidia_smi_memory_total_bytes{instance="${host}"} * 100'' "GPU mem" "B")
        (tgt ''nvidia_smi_temperature_gpu{instance="${host}"}'' "GPU temp" "C")
      ];
      overrides = [{
        matcher = { id = "byName"; options = "GPU temp"; };
        properties = [
          { id = "unit"; value = "celsius"; }
          { id = "custom.axisPlacement"; value = "right"; }
          { id = "color"; value = { mode = "fixed"; fixedColor = "orange"; }; }
        ];
      }];
    });

  mkDashboard = host: spec: {
    id = null;
    uid = "kiosk-${host}";
    title = "Kiosk ${host}";
    tags = [ tag ];
    timezone = "browser";
    schemaVersion = 42;
    version = 1;
    editable = false;
    graphTooltip = 0;
    refresh = "30s";
    time = { from = "now-3h"; to = "now"; };
    templating.list = [ ];
    annotations.list = [ ];
    panels = mkPanels host spec;
  };

  dashboardsDir = pkgs.symlinkJoin {
    name = "kiosk-dashboards";
    paths = lib.mapAttrsToList
      (host: spec: pkgs.writeTextDir "kiosk-${host}.json" (builtins.toJSON (mkDashboard host spec)))
      targets;
  };
in
{
  # 手書きの grafana-dashboards/ とは別プロバイダにする。生成物と手書きを
  # 混ぜると、どちらが真実か追えなくなるため
  services.grafana.provision.dashboards.settings.providers = [{
    name = "kiosk";
    type = "file";
    allowUiUpdates = false;
    disableDeletion = false;
    options = {
      path = dashboardsDir;
      foldersFromFilesStructure = false;
    };
  }];

  # signage.nix がプレイリスト定義で参照する
  _module.args.kioskDashboardTag = tag;
}
