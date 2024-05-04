return {
  settings = {
    ["nil"] = {
      formatting = {
        command = { "nix", "run", "nixpkgs#alejandra" },
      },
      nix = {
        flake = {
          -- calls `nix flake archive` to put a flake and its output to store
          autoArchive = true,
          -- auto eval flake inputs for improved completion
          autoEvalInputs = false,
        },
      },
    },
  },
}
