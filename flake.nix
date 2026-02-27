{
  description = "A NixOS module for remotely-managed Cloudflared tunnels";

  outputs = { self }: {
    nixosModules.default = import ./module.nix;
    nixosModules.cloudflared-remotely = self.nixosModules.default;
  };
}
