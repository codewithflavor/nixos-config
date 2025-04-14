{ config, pkgs, ... }:

let
  batteryCheckScript = pkgs.writeShellScriptBin "battery-alert" ''
    #!/bin/bash

    BATTERY_PATH="/sys/class/power_supply/BAT0/capacity"
    [ ! -f "$BATTERY_PATH" ] && exit 0

    BATTERY_LEVEL=$(cat "$BATTERY_PATH")

    if [ "$BATTERY_LEVEL" -le 10 ]; then
      ${pkgs.util-linux}/bin/wall '⚠️  Battery low: '"$BATTERY_LEVEL"'% remaining!'
    fi
  '';
in
{
  environment.systemPackages = [ batteryCheckScript ];

  systemd.services.battery-alert = {
    description = "Battery low alert service";
    script = "${batteryCheckScript}/bin/battery-alert";
    serviceConfig = {
      Type = "oneshot";
    };
  };

  systemd.timers.battery-alert = {
    description = "Check battery level periodically";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "1min";
      OnUnitActiveSec = "1min";
    };
  };
}

