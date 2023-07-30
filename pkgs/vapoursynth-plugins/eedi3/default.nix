{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, boost
, ocl-icd
, opencl-headers
, vapoursynth
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-eedi3";
  version = "unstable-2019-09-30";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = pname;
    rev = "d11bdb37c7a7118cd095b53d9f8fbbac02a06ac0";
    hash = "sha256-MIUf6sOnJ2uqGw3ixEHy1ijzlLFkQauwtm1vfgmYmcg=";
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
    boost
    ocl-icd
    opencl-headers
    vapoursynth
  ];

  # https://github.com/NixOS/nixpkgs/issues/86131
  preConfigure = ''
    export BOOST_INCLUDEDIR="${lib.getDev boost}/include";
    export BOOST_LIBRARYDIR="${lib.getLib boost}/lib";
  '';

  meta = with lib; {
    description = "Renewed EEDI3 filter for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-EEDI3";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
