{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, vapoursynth
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-hqdn3d";
  version = "unstable-2018-06-29";

  src = fetchFromGitHub {
    owner = "Hinterwaeldlers";
    repo = pname;
    rev = "eb820cb23f7dc47eb67ea95def8a09ab69251d30";
    hash = "sha256-BObHZs7GQW6UFUwohII1MXHtk5ooGh/LfZ3ZsqoPQBU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    vapoursynth
  ];

  configureFlags = [
    "--libdir=${placeholder "out"}/lib/vapoursynth"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Avisynth port of hqdn3d from avisynth/mplayer";
    homepage = "https://github.com/Hinterwaeldlers/vapoursynth-hqdn3d";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
