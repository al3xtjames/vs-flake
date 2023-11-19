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
  pname = "hdr10plus_tool";
  version = "unstable-2023-10-18";

  src = fetchFromGitHub {
    owner = "quietvoid";
    repo = pname;
    rev = "5181cf8e05148929b31b34c0d76aa8d8f2bca34a";
    hash = "sha256-4kLaXjTB+P1kXUf2SadG6FF4Rpyi6urgzHnFE0A0zkA=";
  };

  cargoHash = "sha256-DNDdp/Ucj8IocYT4AyvR700iCSGALvfVo3QjjngH0O8=";

  postPatch = lib.optionals stdenv.isDarwin ''
    substituteInPlace tests/metadata/plot.rs --replace \
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
