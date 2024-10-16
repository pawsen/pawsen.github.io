{ pkgs, ... }:

let
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    hugo
    go  # for hugo modules
    dart-sass
   
  ];
}
