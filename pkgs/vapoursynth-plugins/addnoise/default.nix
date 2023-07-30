{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, vapoursynth
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-addnoise";
  version = "unstable-2023-04-11";

  src = fetchFromGitHub {
    owner = "wwww-wwww";
    repo = "vs-noise";
    rev = "40e0f6b244b2a1429e0dbc0480b2b7914c5f3eca";
    hash = "sha256-pA5W9CxBgoqurMeIe8ekcOYNXr+Q/rFvWufu+7fLiAs=";
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
    description = "AddNoise plugin for VapourSynth";
    longDescription = ''
      AddNoise generates film like noise or other effects (like rain) by adding
      random noise to a video clip. This noise may optionally be horizontally or
      vertically correlated to cause streaking.
    '';
    homepage = "https://github.com/wwww-wwww/vs-noise";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
