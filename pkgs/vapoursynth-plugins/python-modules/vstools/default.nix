{ lib
, buildPythonPackage
, fetchFromGitHub
, vapoursynth
, rich
, stgpytools
}:

buildPythonPackage rec {
  pname = "vs-tools";
  version = "3.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-t3HO9tZnEz2YgSD7LCkPZuPznlPzya4NXSTusH78h5Q=";
  };

  propagatedBuildInputs = [
    rich
    stgpytools
  ];

  nativeBuildInputs = [
    vapoursynth
  ];

  pythonImportsCheck = [
    "vstools"
  ];

  meta = with lib; {
    description = "Functions and utils related to VapourSynth";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vs-tools";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
