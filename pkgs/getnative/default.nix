{ lib
, buildPythonApplication
, fetchFromGitHub
, vapoursynth
, vapoursynthPlugins
, matplotlib
}:

let
  vsPluginInputs = with vapoursynthPlugins; [
    descale
    ffms
  ];
in
buildPythonApplication rec {
  pname = "getnative";
  version = "3.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Infiziert90";
    repo = pname;
    rev = version;
    hash = "sha256-q9Idu7cj19c4kJ5dHj1stBj7OMsI/LVNol6cT1Dj00o=";
  };

  propagatedBuildInputs = [
    matplotlib
    (vapoursynth.withPlugins vsPluginInputs)
  ];

  doCheck = false;

  meta = with lib; {
    description = "Find the native resolution(s) of upscaled material (mostly anime)";
    homepage = "https://github.com/Infiziert90/getnative";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
