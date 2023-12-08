{ lib
, buildPythonPackage
, fetchFromGitHub
, vapoursynth
, vapoursynthPlugins
}:

let
  vsPluginInputs = with vapoursynthPlugins; [
    awarpsharp2
    awarpsharp2-sf
    tcanny
    tedgemask
  ];

  vsPythonInputs = with vapoursynthPlugins.pythonModules; [
    vsexprtools
    vskernels
    vsrgtools
    vstools
  ];
in
buildPythonPackage rec {
  pname = "vs-masktools";
  version = "1.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ojZroVGzG/QL3cvGlsZHb2BlyDRF5R87mMYD4KFgVds=";
  };

  propagatedBuildInputs = vsPluginInputs ++ vsPythonInputs;

  nativeBuildInputs = [
    (vapoursynth.withPlugins vsPluginInputs)
  ];

  pythonImportsCheck = [
    "vskernels"
  ];

  meta = with lib; {
    description = "Various masking tools for VapourSynth";
    longDescription = ''
      vs-masktools aims to provide tools and functions to manage, create, and
      manipulate masks in VapourSynth.
    '';
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vs-masktools";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
