{ lib
, buildPythonPackage
, fetchFromGitHub
, vapoursynth
, vapoursynthPlugins
, nix-update-script
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
  version = "1.6.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6z06IUUPQyXaHjTZlDEewTZwiY2/05AW+GdjLgO5mwk=";
  };

  propagatedBuildInputs = vsPluginInputs ++ vsPythonInputs;

  nativeBuildInputs = [
    (vapoursynth.withPlugins vsPluginInputs)
  ];

  doCheck = false;

  pythonImportsCheck = [
    "vsrgtools"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Wrapper for RGVS, RGSF, and various other functions";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vs-rgtools";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
