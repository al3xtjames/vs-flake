{ lib
, buildPythonPackage
, python
, fetchFromGitHub
, vapoursynth
, vapoursynthPlugins
, matplotlib
}:

let
  vsPluginInputs = with vapoursynthPlugins; [
    akarin
    awarpsharp2
    bilateral
    cas
    ctmf
    descale
    dfttest
    eedi2
    # filter - Windows only
    # filtermod - Windows only
    fmtconv
    miscfilters-obsolete
    mvtools
    # mxnet - Windows only
    removegrain
    sangnom
    tcanny
    temporalmedian
    znedi3
  ];

  vsPythonInputs = with vapoursynthPlugins.pythonModules; [
    mvsfunc
    nnedi3-resample
  ];
in
buildPythonPackage rec {
  pname = "muvsfunc";
  version = "unstable-2023-09-05";
  format = "other";

  src = fetchFromGitHub {
    owner = "WolframRhodium";
    repo = pname;
    rev = "fd9f0413ba3e3e2acb0f412755bac875395f4100";
    hash = "sha256-rif4qXWgR7Gjx504IerILlC7ccl3JgceOOU7ujrE+gs=";
  };

  propagatedBuildInputs = vsPluginInputs ++ vsPythonInputs ++ [
    matplotlib
  ];

  nativeBuildInputs = [
    (vapoursynth.withPlugins vsPluginInputs)
  ];

  installPhase = ''
    runHook preInstall

    install -D muvsfunc.py $out/${python.sitePackages}/muvsfunc.py

    runHook postInstall
  '';

  pythonImportsCheck = [
    "muvsfunc"
  ];

  meta = with lib; {
    description = "Muonium's VapourSynth functions";
    homepage = "https://github.com/WolframRhodium/muvsfunc";
    license = licenses.unfree; # no license
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
