{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, fftw
, vapoursynth
, vsfilterscript
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-mvtools-sf";
  version = "unstable-2020-08-18";

  src = fetchFromGitHub {
    owner = "IFeelBloated";
    repo = pname;
    rev = "38dadba1ef853a90fab51aa886c455587173630b";
    hash = "sha256-dQFHu8DDW7L5RrUraEAlwNrAOgBL2tbQBAgY9jkrUMs=";
  };

  postPatch = ''
    substituteInPlace meson.build --replace \
      "vs.get_pkgconfig_variable('libdir')" \
      "get_option('libdir')"
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    fftw
    vapoursynth
    vsfilterscript
  ];

  meta = with lib; {
    description = "Single Precision MVTools";
    homepage = "https://github.com/IFeelBloated/vapoursynth-mvtools-sf";
    license = licenses.unfree; # no license
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
