{
  inputs,
  outputs,
}: {
  addPackages = final: prev: {
    senyc-nvimconfig = inputs.neovim-config.packages.x86_64-linux.default;
    kx = inputs.kx.packages."x86_64-linux".default;

    # For some reason this does not work argh
    upwork-overlay = prev.upwork.overrideAttrs (old: rec {
      pname = "upwork";
      version = "5.8.0.35";
      versionDirectory = "v5_8_0_35_be1a1520901c4eef";
      src = prev.requireFile {
        name = "${pname}_${version}_amd64.deb";
        url = "https://upwork-usw2-desktopapp.upwork.com/binaries/${versionDirectory}/${pname}_${version}_amd64.deb";
        sha256 = "test";
      };
    });
  };
}
