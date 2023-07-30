{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, vapoursynth
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-fpng";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "Mikewando";
    repo = "vsfpng";
    rev = version;
    hash = "sha256-OteiAug0g6trH24Xj+wAPRVCJYDjCt9YB31mWN1Ep3Y=";
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
    description = "fpng for VapourSynth";
    homepage = "https://github.com/Mikewando/vsfpng";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
