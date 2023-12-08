{ lib
, buildPythonPackage
, fetchFromGitHub
, vapoursynth
, vapoursynthPlugins
}:

let
  vsPluginInputs = with vapoursynthPlugins; [
    eedi2
    eedi2cuda
    eedi3
    eedi3
    nnedi3cl
    sangnom
    sneedif
    znedi3
  ];

  vsPythonInputs = with vapoursynthPlugins.pythonModules; [
    vsexprtools
    vskernels
    vsmasktools
    vsrgtools
    vstools
  ];
in
buildPythonPackage rec {
  pname = "vs-aa";
  version = "1.9.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Lmv5gIyXaPSaju4ufZeSWVxvz6Siv2bFPvRieLPBFWo=";
  };

  propagatedBuildInputs = vsPluginInputs ++ vsPythonInputs;

  nativeBuildInputs = [
    (vapoursynth.withPlugins vsPluginInputs)
  ];

  pythonImportsCheck = [
    "vsaa"
  ];

  meta = with lib; {
    description = "VapourSynth anti aliasing and scaling functions";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vs-aa";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
