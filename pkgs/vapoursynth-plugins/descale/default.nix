{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, vapoursynth
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-descale";
  version = "unstable-2023-04-01";

  src = fetchFromGitHub {
    owner = "Irrational-Encoding-Wizardry";
    repo = "descale";
    rev = "8c53f5d1297dee286e5a854ae5731103614a0583";
    hash = "sha256-bDSoEk1WGvMJ12epXOh7+eWf6HblFpz0Z7STmggpQWw=";
  };

  postPatch = ''
    substituteInPlace meson.build --replace \
      "vs.get_pkgconfig_variable('libdir')" \
      "get_option('libdir')"
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    vapoursynth
  ];

  meta = with lib; {
    description = "VapourSynth plugin to undo upscaling";
    homepage = "https://github.com/Irrational-Encoding-Wizardry/descale";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
