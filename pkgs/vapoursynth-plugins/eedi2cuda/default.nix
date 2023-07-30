{ lib
, stdenv
, fetchFromGitHub
, cmake
, cudaPackages
, boost
, vapoursynth
}:

let
  boost-sync = fetchFromGitHub {
    owner = "boostorg";
    repo = "sync";
    rev = "boost-1.82.0.beta1";
    hash = "sha256-kUiaO/XFsgQplBvCpQDaN/qlUL4g4dFs+q4bpyVLR5E=";
  };

  ext = stdenv.hostPlatform.extensions.sharedLibrary;
in
stdenv.mkDerivation rec {
  pname = "vapoursynth-eedi2cuda";
  version = "unstable-2021-08-27";

  src = fetchFromGitHub {
    owner = "sl1pkn07";
    repo = pname;
    rev = "3f4e1378819d223eeefafecf0c8643b3817d6261";
    hash = "sha256-HytQ+zyZ/2WW5ER4mXiLNZ0h4c2d1gUh1B9VKDBIUFw=";
  };

  patches = [
    ./remove-git-usage.patch
  ];

  nativeBuildInputs = [
    cmake
    cudaPackages.autoAddOpenGLRunpathHook
  ];

  buildInputs = [
    boost
    cudaPackages.cudatoolkit
    vapoursynth
  ];

  cmakeFlags = [
    "-DBoost_INCLUDE_DIRS=${boost-sync}/include"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_CUDA_FLAGS=-I${vapoursynth}/include/vapoursynth"
    "-DENABLE_AVISYNTHPLUS_BINDING=OFF"
    "-DFETCHCONTENT_FULLY_DISCONNECTED=ON"
    "-DVCS_TAG=${src.rev}"
  ];

  installPhase = ''
    runHook preInstall

    install -D libEEDI2CUDA${ext} $out/lib/vapoursynth/libEEDI2CUDA${ext}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Enhanced Edge Directed Interpolation implemented in CUDA";
    # Original upstream: https://github.com/ruihe774/VapourSynth-EEDI2CUDA
    homepage = "https://github.com/sl1pkn07/VapourSynth-EEDI2CUDA";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
