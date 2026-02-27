# nixos-cloudflared-remotely

A simple, declarative NixOS module for running **Remotely Managed Cloudflare Tunnels**.

## 🤔 The Problem

The official NixOS `services.cloudflared` module is designed around locally managed tunnels (requiring `config.yml` and credential files). If you are using Cloudflare's Zero Trust Dashboard to manage your tunnels remotely, you only need to run the daemon with a single token. 

This repository provides a clean, Flake-ready module to do exactly that, running `cloudflared` securely as a systemd service without conflicting with the official module.

## ✨ Features

- **Plug-and-Play**: Just provide your token and enable the service.
- **Flake Native**: Seamlessly integrates into your existing NixOS Flake configuration.
- **Secure by Default**: Runs under a `DynamicUser` in systemd (no root privileges required).
- **Non-Conflicting**: Uses the `services.cloudflared-remotely` namespace, keeping your setup future-proof.

## 🚀 Getting Started

It is incredibly easy to add this to your NixOS Flake.

### 1. Add the Input

Add this repository to your `flake.nix` inputs:

```nix
{
  description = "My NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Add this line
    cloudflared-remotely.url = "github:kenh0u/nixos-cloudflared-remotely";
  };

  outputs = { self, nixpkgs, cloudflared-remotely, ... }: {
    # ... see step 2
  };
}
```

*(Note: This module does not lock a specific `nixpkgs` version, so it will naturally use your system's version of the `cloudflared` package.)*

### 2. Import the Module

Include the module in your `nixosConfigurations`:

```nix
  outputs = { self, nixpkgs, cloudflared-remotely, ... }: {
    nixosConfigurations.my-server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; # or "aarch64-linux"
      modules = [
        # Import the module here
        cloudflared-remotely.nixosModules.default
        
        ./configuration.nix
      ];
    };
  };
```

### 3. Enable and Configure the Service

Finally, enable the service and paste your tunnel token in your `configuration.nix` (or any of your custom host modules):

```nix
{ config, pkgs, ... }:

{
  # ... other configurations ...

  services.cloudflared-remotely = {
    enable = true;
    # Replace with your actual token from the Cloudflare Zero Trust Dashboard
    token = "eyJhIjoi...YOUR_TOKEN_HERE..."; 
  };
}
```

### 4. Deploy

Rebuild your system:

```bash
sudo nixos-rebuild switch --flake .#my-server
```

Your tunnel should now be active and connected to your Cloudflare Zero Trust Dashboard!

## 📄 License

MIT License
