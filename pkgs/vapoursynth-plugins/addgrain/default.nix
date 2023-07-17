{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, vapoursynth
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-addgrain";
  version = "10";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = pname;
    rev = "r${version}";
    hash = "sha256-HNdYDpoyhWkpZZhcji2tWxWTojXKTKBbvm+iHp6Zdeo=";
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
    description = "AddGrain filter for VapourSynth";
    longDescription = ''
      AddGrain generates film like grain or other effects (like rain) by adding
      random noise to a video clip. This noise may optionally be horizontally or
      vertically correlated to cause streaking.
    '';
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-AddGrain";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
