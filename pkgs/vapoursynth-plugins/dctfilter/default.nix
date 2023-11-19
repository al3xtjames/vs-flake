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
  pname = "vapoursynth-dctfilter";
  version = "3.1A";

  src = fetchFromGitHub {
    owner = "AmusementClub";
    repo = pname;
    rev = "r${version}";
    hash = "sha256-B5Yunb/ZdaCMq4t2Bhh2TzA0U+juarM8eyfQ2UVSqTc=";
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
    description = "Renewed DCTFilter filter for VapourSynth";
    homepage = "https://github.com/AmusementClub/VapourSynth-DCTFilter";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
