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
  version = "1.1.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-SuEO5pJ9FiNFOKrYrHqBI4Y9zZNqxINBqIH0x72H/hw=";
  };

  propagatedBuildInputs = vsPluginInputs ++ vsPythonInputs;

  nativeBuildInputs = [
    (vapoursynth.withPlugins vsPluginInputs)
  ];

  doCheck = false;

  pythonImportsCheck = [
    "vsdeband"
  ];

  meta = with lib; {
    description = "Various debanding tools for VapourSynth";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vs-deband";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
