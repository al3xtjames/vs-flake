vs-flake
========

Yet another attempt at packaging VapourSynth plugins for Nix.

### Usage

This repo uses Nix flakes. Derivations for VapourSynth plugins are provided in
`packages.${system}.vapoursynthPlugins`. Python modules are provided under
`packages.${system}.vapoursynthPlugins.pythonModules`. These derivations can be
passed to `vapoursynth.withPlugins` to build a VapourSynth environment.

In addition to VapourSynth plugins, the flake also includes a derivation for
[Yuuno][1]. Like `vapoursynth`, plugins can be passed to Yuuno with
`yuuno.withPlugins`.

The flake also defines a dev shell with all of the packages it provides. This
shell can be run with `nix develop`:

```shell
$ nix develop github:al3xtjames/vs-flake
$ vspipe --version
VapourSynth Video Processing Library
Copyright (c) 2012-2023 Fredrik Mellbin
Core R63
API R4.0
API R3.6
Options: -
```

Only `x86_64-linux` is supported as [VapourSynth in nixpkgs is broken on
Darwin][2].

Flakes don't seem to support nested attribute sets under `packages.${system}`,
so commands such as `nix flake check` and `nix flake show` won't work.

### Credits

This is heavily based on previous packaging efforts:

- [sbruder][3], [tadeokondrak][4], [aidalgol][5], and other [nix-community][6]
  members for maintaining [vs-overlay][7]
- [sshiroi][8] for their [vs-overlay fork][9]
- [sl1pkn07][10] for their [AUR packages][11]

[1]:  https://github.com/Irrational-Encoding-Wizardry/yuuno
[2]:  https://github.com/NixOS/nixpkgs/pull/189446
[3]:  https://github.com/sbruder
[4]:  https://github.com/tadeokondrak
[5]:  https://github.com/aidalgol
[6]:  https://github.com/nix-community
[7]:  https://github.com/nix-community/vs-overlay
[8]:  https://github.com/sshiroi
[9]:  https://github.com/sshiroi/vs-overlay
[10]: https://github.com/sl1pkn07
[11]: https://aur.archlinux.org/packages?K=sl1pkn07&SeB=m&O=50
