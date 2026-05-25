{
  description = "Minimal system config with llama.cpp (binary on macOS, source on Linux)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];

      forAllSystems = nixpkgs.lib.genAttrs systems;

      nixpkgsFor = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      # ---- llama.cpp version pin (macOS binary only) ----
      llamaVersion = "b9297";
      llamaHash = "sha256-BZZYgEuUAHZZNkZ3GSxFFEBCnTmqwkQzJbYyC5okSw8=";

    in {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor system;

          llama =
            if pkgs.stdenv.isDarwin then
              pkgs.stdenv.mkDerivation {
                pname = "llama-cpp";
                version = llamaVersion;

                src = pkgs.fetchurl {
                  url = "https://github.com/ggml-org/llama.cpp/releases/download/${llamaVersion}/llama-${llamaVersion}-bin-macos-arm64.tar.gz";
                  hash = llamaHash;
                };

                dontBuild = true;
                dontConfigure = true;

                installPhase = ''
                  runHook preInstall
                  mkdir -p $out/bin
                  tar -xzf $src -C $out/bin --strip-components=1 || true
                  runHook postInstall
                '';

                meta = {
                  mainProgram = "llama-server";
                  platforms = [ "aarch64-darwin" ];
                };
              }
            else
              pkgs.llama-cpp;

          basePackages = with pkgs; [
            neovim
            nodejs
            pm2
            netcoredbg
            ffmpeg
            create-dmg
            llama
          ];

        in {
          default = pkgs.buildEnv {
            name = "my-packages";
            paths = basePackages;
            pathsToLink = [ "/bin" ];
          };

          inherit llama;
        });

      # ---- optional updater (macOS only) ----
      apps.aarch64-darwin.update = {
        type = "app";
        program =
          let pkgs = nixpkgsFor "aarch64-darwin";
          in toString (pkgs.writeShellScript "update-llama" ''
            set -euo pipefail

            LATEST=$(${pkgs.curl}/bin/curl -s \
              https://api.github.com/repos/ggml-org/llama.cpp/releases/latest \
              | ${pkgs.jq}/bin/jq -r .tag_name)

            echo "Latest: $LATEST"
            echo "Update llamaVersion + hash manually if needed"

            URL="https://github.com/ggml-org/llama.cpp/releases/download/$LATEST/llama-$LATEST-bin-macos-arm64.tar.gz"

            echo "Prefetching..."
            ${pkgs.nix}/bin/nix store prefetch-file --json "$URL"
          '');
      };
    };
}

# ==============================================================================
# COMPLETE SETUP AND USAGE DOCUMENTATION
# ==============================================================================

# 1. SYSTEM CONFIGURATION (Required - Run this first):
#
#    Create /etc/nix/nix.conf with the following content:
#
#    # /etc/nix/nix.conf
#    experimental-features = nix-command flakes
#    auto-optimise-store = true
#    trusted-users = root <username>  # Replace <username> with your actual username
#
#    # Auto garbage collection - keeps disk usage under control
#    min-free = 1073741824    # 1GB - trigger GC when disk space low
#    max-free = 5368709120    # 5GB - GC until this much space is free
#
#    # Optional but recommended for performance and disk space
#    substituters = https://cache.nixos.org/
#    trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=
#    keep-outputs = false
#    keep-derivations = false
#
#    SETUP COMMANDS:
#      whoami                              # Find your username
#      sudo nano /etc/nix/nix.conf        # Edit config (replace <username>)

# 2. RESTART NIX DAEMON (Required after config changes):
#
#    Linux/WSL2:
#      sudo systemctl restart nix-daemon        # Restart daemon
#      sudo systemctl status nix-daemon         # Check status
#      sudo systemctl enable nix-daemon         # Enable at boot
#
#    macOS:
#      sudo launchctl stop org.nixos.nix-daemon && sudo launchctl start org.nixos.nix-daemon
#      sudo launchctl list | grep nix-daemon    # Check if running

# 3. VERIFY CONFIGURATION:
#      nix show-config | grep trusted-users     # Verify trusted user
#      nix-store --optimise                     # Test no warnings
#      nix --version                            # Check flakes enabled

# 4. PACKAGE MANAGEMENT:
#
#    Initial Installation:
#      nix profile add /path/to/this/flake#
#      nix profile add ~/.config/nix#       # If flake is in ~/.config/nix/
#
#    Upgrades:
#      nix flake update /path/to/this/flake     # Update flake inputs
#      nix profile upgrade --all               # Upgrade packages
#
#    Combined update and upgrade:
#      nix flake update ~/.config/nix && nix profile upgrade --all

# 5. MAINTENANCE COMMANDS:
#      nix profile list                         # List installed packages
#      nix-collect-garbage -d                  # Manual garbage collection (auto with config)
#      nix-store --optimise                    # Manual store optimization (auto with config)
#      nix profile wipe-history                # Remove old profile generations

# 6. DAEMON MANAGEMENT REFERENCE:
#
#    Linux/WSL2 (systemd):
#      sudo systemctl start nix-daemon         # Start daemon
#      sudo systemctl stop nix-daemon          # Stop daemon
#      sudo systemctl restart nix-daemon       # Restart daemon
#      sudo systemctl status nix-daemon        # Check status
#      sudo systemctl enable nix-daemon        # Enable at boot
#      sudo systemctl disable nix-daemon       # Disable at boot
#
#    macOS (launchctl):
#      sudo launchctl start org.nixos.nix-daemon   # Start daemon
#      sudo launchctl stop org.nixos.nix-daemon    # Stop daemon
#      sudo launchctl list | grep nix-daemon       # Check status

# 7. TROUBLESHOOTING:
#
#    "Restricted setting" warnings:
#      - Verify: nix show-config | grep trusted-users
#      - Ensure settings are in /etc/nix/nix.conf, not ~/.config/nix/nix.conf
#      - Restart daemon after config changes
#
#    "HOME ownership" warnings:
#      - Avoid sudo with user-level nix commands
#      - Only use sudo for: nix-store --optimise
#
#    Daemon issues:
#      Linux/WSL2: sudo journalctl -u nix-daemon -f
#      macOS: sudo log show --predicate 'subsystem == "org.nixos.nix-daemon"' --last 10m
#
#    Permission issues:
#      sudo chown -R root:nixbld /nix/store
#      sudo chmod 1775 /nix/store


