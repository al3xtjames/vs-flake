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
  version = "1.8.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Irrational-Encoding-Wizardry";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-8RsegLN3rBEgibVzL1WHOgfpo68FsGkoBpf2uGCEl2Y=";
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
    homepage = "https://github.com/Irrational-Encoding-Wizardry/vs-aa";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
