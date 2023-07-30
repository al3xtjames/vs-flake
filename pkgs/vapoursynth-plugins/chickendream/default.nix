{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-chickendream";
  version = "2";

  src = fetchFromGitHub {
    owner = "EleonoreMizo";
    repo = "chickendream";
    rev = "r${version}";
    hash = "sha256-YnrqVS8KBWekWA/w4zJT2jW0OV1+/f/sbZyk5xQ7HkI=";
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
    description = "Realistic film grain generator, plug-in for Vapoursynth and Avisynth+";
    homepage = "https://github.com/EleonoreMizo/chickendream";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
