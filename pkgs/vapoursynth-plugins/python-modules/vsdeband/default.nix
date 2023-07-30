{ lib
, buildPythonPackage
, fetchFromGitHub
, vapoursynth
, vapoursynthPlugins
}:

let
  vsPluginInputs = with vapoursynthPlugins; [
    addgrain
    addnoise
    chickendream
    fgrain-cuda
    neo-f3kdb
    placebo
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
  pname = "vs-deband";
  version = "1.0.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Irrational-Encoding-Wizardry";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QmVnwrD31EToblXwU/17dY8cuRv986V5NEnEs8lqMAc=";
  };

  propagatedBuildInputs = vsPluginInputs ++ vsPythonInputs;

  nativeBuildInputs = [
    (vapoursynth.withPlugins vsPluginInputs)
  ];

  pythonImportsCheck = [
    "vsdeband"
  ];

  meta = with lib; {
    description = "Various debanding tools for VapourSynth";
    homepage = "https://github.com/Irrational-Encoding-Wizardry/vs-deband";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
