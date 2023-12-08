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

let
  ext = stdenv.hostPlatform.extensions.sharedLibrary;
in
stdenv.mkDerivation rec {
  pname = "vapoursynth-SNEEDIF";
  version = "unstable-2023-11-07";

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = pname;
    rev = "d5b52ab4ae1a4e625d770652a06e3464ef5289c4";
    hash = "sha256-N1doUOCkyI8Jnb3FK+S3chrSxp7oLK4Zx997mJI4Osg=";
  };

  patches = [
    ./disable-static-build.patch
  ];

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

  installPhase = ''
    runHook preInstall

    install -D libsneedif${ext} $out/lib/vapoursynth/libsneedif${ext}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Setsugen No Ensemble of Edge Directed Interpolation Functions";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vapoursynth-SNEEDIF";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
