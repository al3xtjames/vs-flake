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
  version = "2.1";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = pname;
    rev = "r${version}";
    hash = "sha256-AORb/bBVT+k9fklM4Mjo0NTqQP4QcY4gvfZLJGATVAw=";
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
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-DCTFilter";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
