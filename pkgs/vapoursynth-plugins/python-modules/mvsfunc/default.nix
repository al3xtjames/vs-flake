{ lib
, buildPythonPackage
, fetchFromGitHub
, vapoursynth
, vapoursynthPlugins
}:

let
  vsPluginInputs = with vapoursynthPlugins; [
    bm3d
    fmtconv
  ];
in
buildPythonPackage rec {
  pname = "mvsfunc";
  version = "unstable-2023-03-20";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = pname;
    rev = "865c7486ca860d323754ec4774bc4cca540a7076";
    hash = "sha256-Zs8LJJri3Uaf8ul9tVNzVgh3Wy/AUJ8kfXlyPeJvcOA=";
  };

  propagatedBuildInputs = vsPluginInputs;

  nativeBuildInputs = [
    (vapoursynth.withPlugins vsPluginInputs)
  ];

  pythonImportsCheck = [
    "mvsfunc"
  ];

  meta = with lib; {
    description = "mawen1250's VapourSynth functions";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/mvsfunc";
    license = licenses.unfree; # no license
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
