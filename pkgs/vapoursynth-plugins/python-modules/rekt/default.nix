{ lib
, buildPythonPackage
, fetchFromGitHub
, vapoursynth
, vapoursynthPlugins
}:

let
  vsPythonInputs = with vapoursynthPlugins.pythonModules; [
    vsutil
    vstaambk
  ];
in
buildPythonPackage rec {
  pname = "rekt";
  version = "unstable-2023-02-19";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "OpusGang";
    repo = pname;
    rev = "c9fc7553a1dbb1a3c50a6fa8774855d8719870e7";
    hash = "sha256-XxfB0NeifCAWbSm4HIwTjeV5Gq++qtKXCeFaoqMVwtI=";
  };

  propagatedBuildInputs = vsPythonInputs;

  nativeBuildInputs = [
    vapoursynth
  ];

  pythonImportsCheck = [
    "rekt"
  ];

  meta = with lib; {
    description = "Simple crop + stack wrapper";
    homepage = "https://github.com/OpusGang/rekt";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
