{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, fontconfig
, pkg-config
, CoreText
, makeFontsConf
}:

let
  fontsConf = makeFontsConf {
    fontDirectories = [ ];
  };
in
rustPlatform.buildRustPackage rec {
  pname = "dovi_tool";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "quietvoid";
    repo = pname;
    rev = version;
    hash = "sha256-QbesKblEUsWgdmocB+QJqa/hbpHNTTPujvGNxdorcuE=";
  };

  cargoHash = "sha256-cO2ot25lnSBBrw5JCSFzJvJPZyU5pwDh1X5pFrkswuc=";

  postPatch = lib.optionals stdenv.isDarwin ''
    substituteInPlace tests/rpu/plot.rs --replace \
      "assert.success().stderr(predicate::str::is_empty());" \
      "assert.success();"
  '';

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    fontconfig
  ] ++ lib.optionals stdenv.isDarwin [
    CoreText
  ];

  # This is needed for the plot tests with sandboxing enabled.
  __impureHostDeps = lib.optionals stdenv.isDarwin [
    "/System/Library/Fonts/Supplemental/Arial.ttf"
  ];

  preCheck = lib.optionals stdenv.isLinux ''
    # Fontconfig error: Cannot load default config file: No such file: (null)
    export FONTCONFIG_FILE="${fontsConf}"
    # Fontconfig error: No writable cache directories
    export XDG_CACHE_HOME="$(mktemp -d)"
  '';

  meta = with lib; {
    description = "CLI tool combining multiple utilities for working with Dolby Vision";
    homepage = "https://github.com/quietvoid/dovi_tool";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
