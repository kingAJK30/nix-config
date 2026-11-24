# nix-refactor

NixOS flake for host `prometheus` (user `king`, nixos-26.05), using flake-parts and import-tree.

## Layout
- Every `.nix` under `modules/` is a flake-parts module, except paths starting with `_`.
  New files must be `git add`ed or the flake cannot see them.
- One feature per file: `modules/features/NAME.nix` defines `flake.modules.nixos.NAME`
  and `flake.modules.homeManager.NAME`. Template: `modules/features/_template.nix`.
- Host config: `modules/hosts/prometheus/configuration.nix`. Host-specific plain NixOS
  modules live in `modules/hosts/prometheus/_config/` (auto-imported).
- Defaults use `lib.mkDefault` so hosts can override.
- Stylix is the single source for colors and fonts. Never hardcode either.

## Commands
- `scripts/build`: build without switching. Safe to run.
- `scripts/format`: format Nix files.
- `scripts/switch` applies the config to the live system. Never run it. Ask me to.
- Never use sudo. Never commit unless asked.

## Scope
Your area is `modules/features/quickshell/`. For any other file, propose the change
and wait for me to apply it.
