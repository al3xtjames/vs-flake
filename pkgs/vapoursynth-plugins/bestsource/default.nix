{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, ffmpeg_6
, jansson
, vapoursynth
}:

let
  libp2p = fetchFromGitHub {
    owner = "sekrit-twc";
    repo = "libp2p";
    rev = "5e65679ae54d0f9fa412ab36289eb2255e341625";
    hash = "sha256-DEl2YmcPmXF7ND0CGgUDOgnLzLhuW6RpKK4flqJ4r6g=";
  };
in
stdenv.mkDerivation rec {
  pname = "vapoursynth-bestsource";
  version = "unstable-2023-10-10";

  src = fetchFromGitHub {
    owner = "vapoursynth";
    repo = "bestsource";
    rev = "20e2135c088f3ae88438fabd35699ffcc8b1dad3";
    hash = "sha256-MZXPLNO2jPWeMXez6qS+KWOmmyofjyGjOWcZIW5CwNY=";
  };

  postUnpack = ''
    ln -s ${libp2p} $sourceRoot/libp2p
  '';

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
    ffmpeg_6
    jansson
    vapoursynth
  ];

  preConfigure = ''
    export AR=${stdenv.cc.targetPrefix}gcc-ar
  '';

  meta = with lib; {
    description = "A super great audio/video source and FFmpeg wrapper";
    longDescription = ''
      BestSource (abbreviated as BS) is a cross-platform wrapper library around
      FFmpeg that ensures sample/frame accurate access to audio and video by
      always linearly decoding the input files.
    '';
    homepage = "https://github.com/vapoursynth/bestsource";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
