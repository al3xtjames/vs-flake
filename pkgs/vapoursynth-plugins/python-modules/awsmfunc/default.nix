{ lib
, buildPythonPackage
, fetchFromGitHub
, vapoursynth
, vapoursynthPlugins
, numpy
}:

let
  vsPluginInputs = with vapoursynthPlugins; [
    bilateral
    fillborders
    fpng
    placebo
    remapframes
    subtext
  ];

  vsPythonInputs = with vapoursynthPlugins.pythonModules; [
    rekt
    vsutil
  ];
in
buildPythonPackage rec {
  pname = "awsmfunc";
  version = "unstable-2023-11-12";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "OpusGang";
    repo = pname;
    rev = "d46075c692877cea3ed0e31af64d082ece81c410";
    hash = "sha256-32PgTmnHbV/DxX2VSwy5Tof2+XiJ12Xxcnm05UegwJk=";
  };

  propagatedBuildInputs = vsPluginInputs ++ vsPythonInputs ++ [
    numpy
  ];

  nativeBuildInputs = [
    (vapoursynth.withPlugins vsPluginInputs)
  ];

  pythonImportsCheck = [
    "awsmfunc"
  ];

  meta = with lib; {
    description = "Awesome VapourSynth functions";
    homepage = "https://github.com/OpusGang/awsmfunc";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
