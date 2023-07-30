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
  pname = "vapoursynth-nnedi3cl";
  version = "8";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = pname;
    rev = "r${version}";
    hash = "sha256-zW/qEtZTDJOTarXbXhv+nks25eePutLDpLck4TuMKUk=";
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
    description = "NNEDI3CL filter for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-NNEDI3CL";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
