{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, vapoursynth
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-deblock";
  version = "6.1";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = pname;
    rev = "r${version}";
    hash = "sha256-TEwxRG9w64mPe9Ey5Z4+9+qlUK2gDOrgpL5XNJXDSmg=";
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
    vapoursynth
  ];

  meta = with lib; {
    description = "Deblock filter for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-Deblock";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
