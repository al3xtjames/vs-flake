{ lib
, stdenv
, fetchFromGitHub
, cmake
, cudaPackages
, vapoursynth
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-nlm-cuda";
  version = "unstable-2023-07-06";

  src = fetchFromGitHub {
    owner = "AmusementClub";
    repo = "vs-nlm-cuda";
    rev = "81019c977745b5d1a79d63073536564c42883762";
    hash = "sha256-skE6IgLsl/uu/wzNkS2eeLP/9W8Zap/WfsZ1c+4xlAg=";
  };

  nativeBuildInputs = [
    cmake
    cudaPackages.autoAddOpenGLRunpathHook
  ];

  buildInputs = [
    cudaPackages.cudatoolkit
    vapoursynth
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_CUDA_ARCHITECTURES=50;61-real;70-virtual;75-real;86-real;89-real"
    "-DCMAKE_CUDA_FLAGS=--use_fast_math"
    "-DCMAKE_INSTALL_LIBDIR=lib/vapoursynth"
    "-DVS_INCLUDE_DIR=${vapoursynth}/include/vapoursynth"
  ];

  meta = with lib; {
    description = "Non-local means denoise filter in CUDA";
    homepage = "https://github.com/AmusementClub/vs-nlm-cuda";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
