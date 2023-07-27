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
  pname = "vapoursynth-bm3d";
  version = "9";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = pname;
    rev = "r${version}";
    hash = "sha256-i7Kk7uFt2Wo/EWpVkGyuYgGZxBuQgOT3JM+WCFPHVrc=";
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
    description = "BM3D denoising filter for VapourSynth";
    longDescription = ''
      BM3D is a state-of-the-art image denoising algorithm. It can be extended
      to video denoising, named V-BM3D, which is also implemented in this
      plugin.
    '';
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
