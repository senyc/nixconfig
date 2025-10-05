{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    modules.user.git.enable = lib.mkEnableOption "Enable git";
  };
  config = lib.mkIf config.modules.user.git.enable {
    programs.git = {
      enable = true;
      userName = "senyc";
      userEmail = "95313103+senyc@users.noreply.github.com";
      ignores = ["local.env"];
      extraConfig = {
        core = {
          pager = "less";
        };
        pull = {
          rebase = true;
        };
        init = {
          defaultBranch = "main";
        };
        url = {
          "git@github.com:" = {
            insteadOf = "gh:";
          };
          "git@github.com-work:" = {
            insteadOf = "gw:";
          };
        };
      };
      hooks = {
        pre-push = pkgs.writeTextFile {
          name = "pre-push";
          executable = true;
          text = /* bash */ ''
              # Check if package.json exists to determine if it's an npm project
              # TODO: update this to not matter what the pwd is
              if [ -f package.json ]; then
                echo "Found package.json. Running TypeScript compiler..."
                # Run TypeScript compiler
                npx tsc --noEmit
                # Run eslint
                # npx eslint .

                # Check if tsc was successful
                if [ $? -ne 0 ]; then echo "TypeScript compilation failed. Push aborted."
                  exit 1
                fi

              else
                echo "No package.json found. Skipping TypeScript compilation."
              fi
            '';
        };
        commit-msg = pkgs.writeTextFile {
          name = "commit-msg";
          executable = true;
          text = /* bash */
            ''
              title=$(head -1 "$1")

              # Checking that commit follows commit guidelines
              #   based on: https://www.conventionalcommits.org/en/v1.0.0/
              if ! (echo "$title" | grep -qE "^Merge"); then
                  if ! (echo "$title" | grep -qE "^(.+)(\(.+?\))?!?: .{1,}$"); then
                      echo "Aborting commit. Your commit message is invalid. Please follow the conventional commit guidelines" >&2
                      exit 1
                  fi
              fi

              if ! which aspell > /dev/null; then
                  echo "Please install aspell for proper spell checking" >&2
                  exit 1
              fi

              # Checking for misspelled words
              misspelled_words="$(cat "$1" | ${pkgs.aspell}/bin/aspell --list --lang=en_US | tr '\n' ' ')"
              if [ -n "$misspelled_words" ]; then
                  echo "Found misspelled words: $misspelled_words" >&2
                  echo "Would you like to commit anyways [y|n]"
                  read -r < /dev/tty
                  if [[ "$REPLY" == 'y' ]] || [[ "$REPLY" == 'Y' ]]; then
                    echo "skipping..."
                  else
                    echo "Please fix the spelling mistakes and commit your changes again" >&2
                    exit 1
                  fi
              fi
            '';
        };
      };
    };

    # Adds English dictionary for aspell
    home.packages = [
      pkgs.aspellDicts.en
    ];
  };
}
