# Nix Configuration
My personal, modular NixOS configuration using home-manager and Flake-parts.

## Hosts
| Host | Platform | Description |
| ---- | -------- | ----------- |
| Prometheus | NixOS x86_64-linux | Main PC, all the tools |
| aaron-macbook | Nix-Darwin aarch64-darwin | MacOS configuration, not complete setup |

## Structure & Design
```text
modules/
├── attrs/     # Bundles of features and packages
├── features/  # Reusable system and home-manager modules
├── hosts/     # Host-specific configurations
├── users/     # User configuration and application settings
├── system/    # Hardware and system-level modules
└── parts.nix  # Flake-parts setup
```

### Configuration bundles
- **Base:** Common system settings and Git configuration.
- **Development:** Development tools and local LLM infrastructure.
- **Graphical:** Fonts, audio, desktop applications, and terminal configuration.

Hosts compose these bundles with individual features.

### Features
- **Desktop:** Sway, Foot, and Rofi
- **Editors:** Doom Emacs and Neovim
- **Development:** Git and CLI tools
- **Gaming:** Steam and Prism Launcher
- **Local AI:** Llama.cpp w/ Vulkan, Open WebUI, and OpenCode
- **MacOS:** nix-darwin w/ Home-Manager

## Building and Deployment
### Prerequisites
- Nix (or NixOS) installed on target machine
- Nix flakes enabled
- Git installed
- For macOS, the required nix-darwin setup completed.

### 1. Clone the Repository
```bash
git clone https://github.com/kingajk30/nix-config.git
cd nix-config
```
### 2. Validate the Flake
From the repository root, check the flake:
```bash
nix flake check
```

### 3. Build and Apply the Configuration
#### NixOS: prometheus
Build the system configuration:
```bash
sudo nixos-rebuild build --flake .#prometheus
```

Apply the configuration:
```bash
sudo nixos-rebuild switch --flake .#prometheus
```

#### MacOS: aaron-macbook
Build the nix-darwin configuration:
```bash
nix build .#darwinConfigurations.aaron-macbook.system
```

Apply the configuration:
```bash
sudo darwin-rebuild switch --flake .#aaron-macbook
```

### Notes
- Run commands from repository root.
- The configurations contain host-specific settings and are not intended to be applied unchanged to other machines.
- The macOS configuration is a work in progress and may require additional manual setup.

## Local LLM
The prometheus host configures llama.cpp as an OpenAI-compatible API server on port 8080, with Open WebUI on port 3000.

OpenCode and Emacs are configured to use the local inference endpoint.

Review network exposure and authentication settings before making these services accessible beyond the local machine.

## Customization
- Add reusable functionality under `modules/features/`.
- Group commonly enabled features and standalone packages under `modules/attrs/`.
- Add new systems and host-specific settings under `modules/hosts/`.
- Put user-specific application configuration under `modules/users/`.

After making changes, evaluate and build the relevant host configuration before applying it.

## License
This project is licensed under the MIT License. See LICENSE for details.
