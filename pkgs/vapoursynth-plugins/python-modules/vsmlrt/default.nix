{ lib
, buildPythonPackage
, python
, vapoursynth
, vapoursynthPlugins
, nix-update-script
}:

let
  vsPluginInputs = with vapoursynthPlugins; [
    akarin
    trt
  ];
in
buildPythonPackage {
  inherit (vapoursynthPlugins.trt) version src;

  pname = "vs-mlrt";
  format = "other";

  propagatedBuildInputs = vsPluginInputs;

  nativeBuildInputs = [
    (vapoursynth.withPlugins vsPluginInputs)
  ];

  installPhase = ''
    runHook preInstall

    install -D scripts/vsmlrt.py $out/${python.sitePackages}/vsmlrt.py

    runHook postInstall
  '';

  pythonImportsCheck = [
    "vsmlrt"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Efficient CPU/GPU/Vulkan ML Runtimes for VapourSynth";
    homepage = "https://github.com/AmusementClub/vs-mlrt";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
