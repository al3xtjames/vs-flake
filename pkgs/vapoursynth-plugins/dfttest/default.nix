{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, fftwFloat
, vapoursynth
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-dfttest";
  version = "unstable-2022-04-15";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = pname;
    rev = "bc5e0186a7f309556f20a8e9502f2238e39179b8";
    hash = "sha256-HGk9yrs6T3LAP0I5GPt9b4LwldXtQDG277ffX6xMr/4=";
  };

  postPatch = ''
    substituteInPlace meson.build --replace \
      "vapoursynth_dep.get_pkgconfig_variable('libdir')" \
      "get_option('libdir')"
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    fftwFloat
    vapoursynth
  ];

  meta = with lib; {
    description = "DFTTest filter for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-DFTTest";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
