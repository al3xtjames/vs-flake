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
  pname = "vapoursynth-fft3dfilter";
  version = "2.AC3";

  src = fetchFromGitHub {
    owner = "AmusementClub";
    repo = pname;
    rev = "R${version}";
    hash = "sha256-onfqDYAneTKNeg0a/p6m1sgaKHdMZxSjslZC32Jc2mw=";
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
    description = "VapourSynth port of FFT3DFilter, @AmusementClub internal fork";
    homepage = "https://github.com/AmusementClub/VapourSynth-FFT3DFilter";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
