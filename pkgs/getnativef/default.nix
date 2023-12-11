{ lib
, buildPythonApplication
, fetchFromGitHub
, vapoursynth
, vapoursynthPlugins
, matplotlib
, numpy
, rich
}:

let
  vsPythonInputs = with vapoursynthPlugins.pythonModules; [
    vskernels
    vsscale
    vssource
    vstools
  ];
in
buildPythonApplication rec {
  pname = "getnativef";
  version = "unstable-2023-11-14";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Vodes";
    repo = pname;
    rev = "7038fed0737287f2bd32580ef549f6facb4932bf";
    hash = "sha256-zHVT6qzYie8XJKDe8/DzgNUc70SCMCCSeykuDylpz0o=";
  };

  propagatedBuildInputs = vsPythonInputs ++ [
    matplotlib
    numpy
    rich
    (vapoursynth.withPlugins vsPythonInputs)
  ];

  doCheck = false;

  meta = with lib; {
    description = "Find the native (fractional) resolution(s) of upscaled material (mostly anime)";
    homepage = "https://github.com/Vodes/getnativef";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
