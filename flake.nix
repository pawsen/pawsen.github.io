# see example https://github.com/pawsen/remove-duplicate/blob/main/flake.nix

# nix shell is meant to spawn a shell with an application in scope - that's why
# it modifies only the PATH envvar (think: if you want to ad hoc launch some
# app, but don't want to actually install it).

# nix develop is meant to spawn a shell with an application's development
# dependencies in scope (think: if you want to hack on an application locally,
# compile it etc.).

{
  description = "Paws personal blog";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # Import theme
    stack = {
      url = github:CaiJimmy/hugo-theme-stack;
      flake = false;
    };
    ananke = {
      url = github:theNewDynamic/gohugo-theme-ananke;
      flake = false;
    };
    terminal = {
      url = github:panr/hugo-theme-terminal;
      flake = false;
    };
    hugo-coder = {
      url = github:luizdepra/hugo-coder;
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, stack, ananke, terminal, hugo-coder }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        blog = pkgs.stdenv.mkDerivation {
          name = "blog";
          # Exclude themes and public folder from build sources
          src = builtins.filterSource
            (path: type: !(type == "directory" &&
              (baseNameOf path == "themes" ||
                baseNameOf path == "public")))
            ./.;
          # Link theme to themes folder and build
          buildPhase = ''
            mkdir -p themes
            ln -s ${stack} themes/stack
            ln -s ${ananke} themes/ananke
            ln -s ${terminal} themes/terminal
            ln -s ${hugo-coder} themes/hugo-coder
            ${pkgs.hugo}/bin/hugo --minify
          '';
          installPhase = ''
            cp -r public $out
          '';
          meta = with pkgs.lib; {
            description = "Paw's personal blog";
            platforms = platforms.all;
          };
        };
      in
      {
        packages = {
          blog = blog;
          default = blog;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [ hugo ];
          # Link theme to themes folder
          shellHook = ''
            mkdir -p themes
            ln -sf ${stack} themes/stack
            ln -sf ${ananke} themes/ananke
            ln -sf ${terminal} themes/terminal
            ln -sf ${hugo-coder} themes/hugo-coder
          '';
        };
      });
}
