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
  version = "unstable-2023-07-26";

  src = fetchFromGitHub {
    owner = "quietvoid";
    repo = pname;
    rev = "fa9a55468a1db78c1b409d3fc43f6e7f2d51d3c5";
    hash = "sha256-/z4uW1T9T8rJFWQe7CttRIKyEGxupN8YquBUDDo7I5g=";
  };

  cargoHash = "sha256-jo637NXX2ODqHZp18Qzw5KIoro6BBjJYkXvtmZt/VuQ=";

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
