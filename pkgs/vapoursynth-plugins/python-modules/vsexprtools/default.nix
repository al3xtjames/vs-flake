{ lib
, buildPythonPackage
, fetchFromGitHub
, vapoursynth
, vapoursynthPlugins
, nix-update-script
}:

let
  vsPluginInputs = with vapoursynthPlugins; [
    akarin
  ];

  vsPythonInputs = with vapoursynthPlugins.pythonModules; [
    vstools
  ];
in
buildPythonPackage rec {
  pname = "vs-exprtools";
  version = "1.5.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-cSuwyncdQnQtYWFL+qzwZ5hCnrZ4ESMB38skzef/XMk=";
  };

  propagatedBuildInputs = vsPluginInputs ++ vsPythonInputs;

  nativeBuildInputs = [
    (vapoursynth.withPlugins vsPluginInputs)
  ];

  pythonImportsCheck = [
    "vsexprtools"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "VapourSynth functions and helpers for writing RPN expressions";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vs-exprtools";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
