{
  description = "Utah Lean Seminar worksheets — VS Code with the lean4 extension";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    # vscode-extensions.leanprover.lean4 comes from this separate pin, matching
    # the other lean projects on this box — not because the extension needs
    # matching, just reusing a known-good revision instead of an unpinned one.
    nixpkgs-lean.url = "github:NixOS/nixpkgs/624af665418d3c65d544145b4d34ad696439570e";
  };

  outputs = { self, nixpkgs, nixpkgs-lean }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f:
        nixpkgs.lib.genAttrs systems (system:
          f system nixpkgs.legacyPackages.${system} nixpkgs-lean.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (system: pkgs: lpkgs:
        let
          # VS Code with the lean4 extension baked in. VS Code itself is
          # unfree, so it comes from a scoped allowUnfree import rather than
          # legacyPackages; the extension is Apache-2.0. The wrapper pins
          # --extensions-dir to the store, so this instance runs exactly this
          # extension set.
          vscodeLean = (import nixpkgs-lean {
            inherit system;
            config.allowUnfree = true;
          }).vscode-with-extensions.override {
            vscodeExtensions = [
              lpkgs.vscode-extensions.leanprover.lean4
              # declared dependency of the lean4 extension (lakefile.toml);
              # the immutable extensions dir means VS Code can't add it
              lpkgs.vscode-extensions.tamasfe.even-better-toml
              # The colour theme ("Cute", a light theme by WebFreak); not
              # packaged in nixpkgs, so fetched from the marketplace by hash.
              (lpkgs.vscode-utils.extensionFromVscodeMarketplace {
                name = "cute-theme";
                publisher = "webfreak";
                version = "0.0.4";
                sha256 = "1ib2j4hlgs4fxqkl2cvwjxsxr4zwplz8x06j76byk8mcjq0msd0v";
              })
            ];
          };
        in
        {
          # The project itself is elan-managed (lean-toolchain + lakefile.toml,
          # `lake exe cache get` for mathlib) — this shell only needs to supply
          # elan (in case it's not already on PATH) and an editor.
          default = pkgs.mkShell {
            packages = [
              pkgs.elan
              vscodeLean
            ];
          };
        });
    };
}
