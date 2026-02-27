{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.cloudflared-remotely;
in
{
  options.services.cloudflared-remotely = {
    enable = mkEnableOption "Remotely managed Cloudflare Tunnel";
    token = mkOption {
      type = types.str;
      description = "Cloudflare Tunnel Token";
    };

    edgeIpVersion = mkOption {
      type = types.enum [ "auto" "4" "6" ];
      default = "auto";
      description = "Preferred edge IP version (auto, 4, or 6). Defaults to auto.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.cloudflared ];

    systemd.services.cloudflared-remotely = {
      description = "Cloudflare Tunnel (Remotely Managed)";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        TimeoutStartSec = 0;
        Type = "notify";
        ExecStart = "${pkgs.cloudflared}/bin/cloudflared --no-autoupdate tunnel --edge-ip-version ${cfg.edgeIpVersion} run --token ${cfg.token}";
        Restart = "always";
        RestartSec = "5s";
        DynamicUser = true;
      };
    };
  };
}
