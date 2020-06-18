with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "env";
  buildInputs = [
    sqlite
    ruby.devEnv
    bashInteractive
    libxml2
    libxslt
    zlib
    pkg-config
    nodejs
    yarn
  ];
}
