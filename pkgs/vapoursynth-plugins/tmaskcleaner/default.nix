{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, vapoursynth
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-tmaskcleaner";
  version = "unstable-2023-06-02";

  src = fetchFromGitHub {
    owner = "Beatrice-Raws";
    repo = pname;
    rev = "5482673c1b2d00f9d81c90b8124334a6cb5dca21";
    hash = "sha256-8qmHsatX3r/FWmbhBOwvWq/tjNIMLmBiwCE4+rM+SYI=";
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
    vapoursynth
  ];

  meta = with lib; {
    description = "A really simple mask cleaning plugin for VapouSynth";
    longDescription = ''
      A really simple mask cleaning plugin for VapourSynth based on tmaskcleaner
      for AviSynth. It discards all areas of less than length pixels with values
      bigger or equal to thresh.
    '';
    homepage = "https://github.com/Beatrice-Raws/VapourSynth-TMaskCleaner";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
