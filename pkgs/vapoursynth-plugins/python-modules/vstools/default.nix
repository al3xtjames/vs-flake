{ lib
, buildPythonPackage
, fetchFromGitHub
, vapoursynth
, rich
}:

buildPythonPackage rec {
  pname = "vs-tools";
  version = "2.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Irrational-Encoding-Wizardry";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Ui8MpSR4079SH3R8Wk7ZqUReoQPhMUV7io062tZTXrU=";
  };

  propagatedBuildInputs = [
    rich
  ];

  nativeBuildInputs = [
    vapoursynth
  ];

  pythonImportsCheck = [
    "vstools"
  ];

  meta = with lib; {
    description = "Functions and utils related to VapourSynth";
    homepage = "https://github.com/Irrational-Encoding-Wizardry/vs-tools";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
