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
  version = "unstable-2023-07-20";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "OpusGang";
    repo = pname;
    rev = "0bdcb2d2f149676819471fbeaa606731ab2d833c";
    hash = "sha256-7yooKBfMVfXj66PQ0wX2XCUBEZpvMgubahb2rA0HDgk=";
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
