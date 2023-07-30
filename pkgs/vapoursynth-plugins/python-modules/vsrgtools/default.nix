{ lib
, buildPythonPackage
, fetchFromGitHub
, vapoursynth
, vapoursynthPlugins
}:

let
  vsPluginInputs = with vapoursynthPlugins; [
    akarin
    removegrain
    removegrain-sf
  ];

  vsPythonInputs = with vapoursynthPlugins.pythonModules; [
    vsexprtools
    vspyplugin
    vstools
  ];
in
buildPythonPackage rec {
  pname = "vs-rgtools";
  version = "1.5.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Irrational-Encoding-Wizardry";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-z3T1w6xolGEri7fnfk8A8RR+UlX5OQz/sHrX7L54UhU=";
  };

  propagatedBuildInputs = vsPluginInputs ++ vsPythonInputs;

  nativeBuildInputs = [
    (vapoursynth.withPlugins vsPluginInputs)
  ];

  doCheck = false;

  pythonImportsCheck = [
    "vsrgtools"
  ];

  meta = with lib; {
    description = "Wrapper for RGVS, RGSF, and various other functions";
    homepage = "https://github.com/Irrational-Encoding-Wizardry/vs-rgtools";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
