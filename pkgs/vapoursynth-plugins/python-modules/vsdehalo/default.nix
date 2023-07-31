{ lib
, buildPythonPackage
, fetchFromGitHub
, vapoursynth
, vapoursynthPlugins
}:

let
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
  pname = "vs-dehalo";
  version = "1.7.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Irrational-Encoding-Wizardry";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-zBdH0NeyS4uxxSdXp4K9M2jRb5eoqhWWGH+WBVaGmWM=";
  };

  propagatedBuildInputs = vsPythonInputs;

  nativeBuildInputs = [
    vapoursynth
  ];

  pythonImportsCheck = [
    "vsdehalo"
  ];

  meta = with lib; {
    description = "VapourSynth dehaloing functions";
    homepage = "https://github.com/Irrational-Encoding-Wizardry/vs-dehalo";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
