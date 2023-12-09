{ lib
, buildPythonPackage
, fetchFromGitHub
, vapoursynth
, vapoursynthPlugins
}:

let
  vsPluginInputs = with vapoursynthPlugins; [
    awarpsharp2
    tcanny
  ];

  vsPythonInputs = with vapoursynthPlugins.pythonModules; [
    vsaa
    vsdenoise
    vsexprtools
    vskernels
    vsmasktools
    vsrgtools
    vsscale
    vstools
  ];
in
buildPythonPackage rec {
  pname = "vs-dehalo";
  version = "1.8.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-zimlLVkSlOHcWYxm3tiAt93zIBnmHgPCNqjXEHUjTZg=";
  };

  propagatedBuildInputs = vsPluginInputs ++ vsPythonInputs;

  nativeBuildInputs = [
    (vapoursynth.withPlugins vsPluginInputs)
  ];

  doCheck = false;

  pythonImportsCheck = [
    "vsdehalo"
  ];

  meta = with lib; {
    description = "VapourSynth dehaloing functions";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vs-dehalo";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
