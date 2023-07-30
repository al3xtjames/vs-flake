{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-fmtconv";
  version = "unstable-2023-01-28";

  src = fetchFromGitHub {
    owner = "EleonoreMizo";
    repo = "fmtconv";
    rev = "3eec42f8aaf86f3327b9190c6b25a0c9eca22028";
    hash = "sha256-odgnkH3Ofhbz+PSc0BHm3rlJMNsHg089wIetOxCZi8Q=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  preAutoreconf = ''
    cd build/unix
  '';

  configureFlags = [
    "--libdir=${placeholder "out"}/lib/vapoursynth"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Format conversion tools for Vapoursynth and Avisynth+";
    homepage = "https://github.com/EleonoreMizo/fmtconv";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
