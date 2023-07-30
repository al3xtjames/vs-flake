{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, vapoursynth
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-miscfilters-obsolete";
  version = "unstable-2022-01-24";

  src = fetchFromGitHub {
    owner = "vapoursynth";
    repo = "vs-miscfilters-obsolete";
    rev = "07e0589a381f7deb3bf533bb459a94482bccc5c7";
    hash = "sha256-WEhpBTNEamNfrNXZxtpTGsOclPMRu+yBzNJmDnU0wzQ=";
  };

  postPatch = ''
    substituteInPlace meson.build --replace \
      "dep.get_pkgconfig_variable('libdir')" \
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
    description = "Random collection of filters that mostly are useful for Avisynth compatibility";
    homepage = "https://github.com/vapoursynth/vs-miscfilters-obsolete";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
