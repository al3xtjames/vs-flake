{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, vapoursynth
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-dpid";
  version = "6";

  src = fetchFromGitHub {
    owner = "WolframRhodium";
    repo = pname;
    rev = "r${version}";
    hash = "sha256-N+n4Ch2BsS4dJVKcZ2VbseeXw9e3ffSeG8wd244Y2o4=";
  };

  postPatch = ''
    substituteInPlace Source/meson.build --replace \
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

  preConfigure = ''
    cd Source
  '';

  meta = with lib; {
    description = "Rapid, Detail-Preserving Image Downscaler for VapourSynth";
    homepage = "https://github.com/WolframRhodium/VapourSynth-dpid";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
