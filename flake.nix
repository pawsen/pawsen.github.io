# use with
# nix develop -c $SHELL
{
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; };

  outputs = { nixpkgs, ... }:
    let forAllSystems = nixpkgs.lib.genAttrs [ "aarch64-linux" "x86_64-linux" ];
    in {
      devShells = forAllSystems (system:
        let pkgs = import nixpkgs { inherit system; };
        in with pkgs; rec {
          default = mkShell {
            # Put shell variables here

            buildInputs = with pkgs; [
              hugo
              dart-sass
              # go  # for hugo modules
            ];

            shellHook = ''
            echo "###########"
            echo "run"
            echo "emacs --batch --load scripts/ox-roam.el --funcall export-org-roam-files"
            echo "hugo serve -D --logLevel debug --disableFastRender"
            echo "###########"
            '';
          };
        });
      packages = forAllSystems (system: {
        default =
          nixpkgs.legacyPackages.${system}.callPackage ./default.nix { };
      });
    };
}
