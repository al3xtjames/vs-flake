{ lib
, stdenv
, fetchFromGitHub
, cmake
, cudaPackages ? { }
, vapoursynth
, config
, cudaSupport ? config.cudaSupport
, gccVectorSupport ? false
}:

let
  ext = stdenv.hostPlatform.extensions.sharedLibrary;
in
stdenv.mkDerivation rec {
  pname = "vapoursynth-dfttest2";
  version = "6";

  src = fetchFromGitHub {
    owner = "AmusementClub";
    repo = "vs-dfttest2";
    rev = "v${version}";
    hash = "sha256-sRBuyaKVcCtqMpzsyQvRRGffxofsh1QyZLsIqVXv+hc=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
  ] ++ lib.optionals cudaSupport (with cudaPackages; [
    autoAddOpenGLRunpathHook
    cuda_nvcc
  ]);

  buildInputs = [
    vapoursynth
  ] ++ lib.optionals cudaSupport (with cudaPackages; [
    cuda_cudart
    cuda_nvrtc
    libcufft
  ]);

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DENABLE_CUDA=${lib.boolToString cudaSupport}"
    "-DENABLE_GCC=${lib.boolToString gccVectorSupport}"
    "-DVS_INCLUDE_DIR=${vapoursynth}/include/vapoursynth"
  ];

  postInstall = ''
    mkdir -p $out/lib/vapoursynth
    find $out/lib -name '*${ext}' -exec ln -s "{}" $out/lib/vapoursynth/ \;
  '';

  meta = with lib; {
    description = "DFTTest re-implemetation for VapourSynth (CPU and CUDA)";
    homepage = "https://github.com/AmusementClub/vs-dfttest2";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
