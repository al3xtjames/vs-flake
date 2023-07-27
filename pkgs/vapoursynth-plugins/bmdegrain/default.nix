{ lib
, stdenv
, fetchFromGitHub
, cmake
, vapoursynth
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-bmdegrain";
  version = "unstable-2023-02-06";

  src = fetchFromGitHub {
    owner = "AmusementClub";
    repo = "vs-bmdegrain";
    rev = "92d902f90a6462d50013b9312355a1e08a55c672";
    hash = "sha256-oqGdSXgwhP4EiWLthIF6Ah2+5EmvlCxadc1KJGppMb0=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    vapoursynth
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_INSTALL_LIBDIR=lib/vapoursynth"
    "-DVS_INCLUDE_DIR=${vapoursynth}/include/vapoursynth"
  ];

  meta = with lib; {
    description = "Denoising inspired by bm3d and mvdegrain";
    homepage = "https://github.com/AmusementClub/vs-bmdegrain";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
