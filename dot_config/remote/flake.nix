{
  description = "CLI tools for the remote development VPS";

  # `nixos-unstable` keeps developer tools reasonably current. The generated
  # flake.lock pins it to one exact revision until we deliberately update it.
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      # AlphaVPS4G reported x86_64 Linux during the read-only inventory.
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;

        # Claude Code is distributed under a proprietary license. Permit only
        # that package instead of enabling every unfree Nix package globally.
        config.allowUnfreePredicate = pkg:
          builtins.elem (nixpkgs.lib.getName pkg) [ "claude-code" ];
      };

      cliTools = pkgs.buildEnv {
        name = "cli-tools";

        paths = with pkgs; [
          bat
          claude-code
          codex
          eza
          fd
          fzf
          gh
          gcc
          gnumake
          jq
          neovim
          nodejs
          ov
          python3
          ripgrep
          unzip
          zoxide
        ];

        # Link executables and shared support data into one compact profile.
        pathsToLink = [
          "/bin"
          "/share"
        ];
      };
    in
    {
      packages.${system} = {
        cli-tools = cliTools;
        default = cliTools;
      };
    };
}
