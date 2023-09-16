{ lib
, stdenv
, fetchFromGitLab
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-fmtconv";
  version = "unstable-2023-09-02";

  src = fetchFromGitLab {
    owner = "EleonoreMizo";
    repo = "fmtconv";
    rev = "f2d8f825aad873284e56baac081393c0f7320b35";
    hash = "sha256-3UnboHDeE1bnTV1djyoG6ONUbBEsbYNiPfIjDe5+AfI=";
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
    homepage = "https://gitlab.com/EleonoreMizo/fmtconv";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
