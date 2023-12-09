{ lib
, buildPythonPackage
, fetchFromGitHub
, vapoursynth
, vapoursynthPlugins
}:

let
  vsPluginInputs = with vapoursynthPlugins; [
    akarin
    tivtc
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
  pname = "vs-deinterlace";
  version = "0.6.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6ehkALn0R8hyVDmoym0BMB9yAMftaCXKgFe1rOlbc9w=";
  };

  propagatedBuildInputs = vsPluginInputs ++ vsPythonInputs;

  nativeBuildInputs = [
    (vapoursynth.withPlugins vsPluginInputs)
  ];

  doCheck = false;

  pythonImportsCheck = [
    "vsdeinterlace"
  ];

  meta = with lib; {
    description = "VapourSynth functions for deinterlacing";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vs-deinterlace";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
