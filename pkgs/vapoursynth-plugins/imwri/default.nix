{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, imagemagick
, libheif
, libjxl
, vapoursynth
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-imwri";
  version = "2";

  src = fetchFromGitHub {
    owner = "vapoursynth";
    repo = "vs-imwri";
    rev = "R${version}";
    hash = "sha256-1YDmpFZ3S75OjpNoSXOZOtsi1BrI+sFCrtcWdqNrMCA=";
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
    imagemagick
    libheif # TODO: is this actually needed?
    libjxl # TODO: is this actually needed?
    vapoursynth
  ];

  meta = with lib; {
    description = "Image reader and writer for VapourSynth using the ImageMagick library";
    homepage = "https://github.com/vapoursynth/vs-imwri";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
