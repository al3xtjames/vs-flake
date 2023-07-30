{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, vapoursynth
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-tcanny";
  version = "unstable-2022-04-23";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = pname;
    rev = "14ac2ceeb59afc7089974d0ae233fe8d0ea183c8";
    hash = "sha256-kSveRh2Ej4UWecEZTCmjLOnIKR4U4RIjQl2ffpLaxOI=";
  };

  postPatch = ''
    substituteInPlace meson.build --replace \
      "vapoursynth_dep.get_variable(pkgconfig: 'libdir')" \
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

  preConfigure = ''
    export AR=${stdenv.cc.targetPrefix}gcc-ar
  '';

  meta = with lib; {
    description = "TCanny filter for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-TCanny";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
