{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options = {
    modules.system.ollama.enable = mkEnableOption "Enable default ollama configuration";
  };
  config = mkIf config.modules.system.ollama.enable {

    environment.sessionVariables = {
      HSA_OVERRIDE_GFX_VERSION = "11.0.0";
    };

    nixpkgs.config.rocmSupport = true;
    services = {
      ollama = {
        enable = true;

        loadModels = [
          "gemma3:12b"
        ];

        acceleration = "rocm";

        # https://github.com/NixOS/nixpkgs/issues/308206
        # https://rocm.docs.amd.com/en/latest/reference/gpu-arch-specs.html
        rocmOverrideGfx = "11.0.0"; # gfx1100

        host = "127.0.0.1";
        port = 11434;
        openFirewall = true;
      };

      nextjs-ollama-llm-ui = {
        enable = true;
        port = 8091;
        ollamaUrl = "http://127.0.0.1:11434";
      };
    };

    hardware.amdgpu.opencl.enable = true;
    hardware.graphics = {
      enable32Bit = true;
      extraPackages = [pkgs.rocmPackages.clr.icd];
    };

    environment.systemPackages = with pkgs; [
      rocmPackages.clr.icd
    ];

    systemd.tmpfiles.rules = [
      "L+    /opt/rocm   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];
  };
}
