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
  version = "1.1.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Irrational-Encoding-Wizardry";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-RAG++RwcNcPSkN5T8tmgoh/2gXuGTMAqfgQgkIRlDmk=";
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
    homepage = "https://github.com/Irrational-Encoding-Wizardry/vs-masktools";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
