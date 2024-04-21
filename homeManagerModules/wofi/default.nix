{
  pkgs,
  config,
  lib,
  ...
}: {

  options = {
    wofi.enable = lib.mkEnableOption "Enable wofi";
  };
  config = lib.mkIf config.wofi.enable {
    programs.wofi = {
      enable = true;
      settings = {
        hide_scroll=true;
        show="dmenu";
        width="25%";
        lines=7;
        line_wrap="word";
        term="alacritty";
        allow_markup=true;
        always_parse_args=false;
        show_all=true;
        parse_search = true;
        print_command=true;
        layer="overlay";
        allow_images=true;
        sort_order="default";
        gtk_dark=true;
        prompt="";
        image_size=24;
        display_generic=false;
        location="center";
        key_expand="Tab";
        insensitive=true;
      };
      style = ''
        * {
          font-family: JetBrainsMono;
          color: #e5e9f0;
          background: transparent;
        }

        #window {
          background: rgba(41, 46, 66, 0.5);
          padding: 10px;
          border-radius: 20px;
          border: 3px solid #ebbcba;
        }

        #input {
          padding: 10px;
          margin-bottom: 10px;
          border-radius: 15px;
          border: 1px solid #ebbcba;
        }

        #input:focus {
          box-shadow: none;
        }

        #outer-box {
          padding: 20px;
        }

        #img {
          margin-right: 6px;
        }

        #entry {
          padding: 10px;
          border-radius: 15px;
        }

        #entry:selected {
          background-color: rgba(41, 46, 66, 0.6);
        }

        #text {
          margin: 2px;
        }
      '';
    };
    home.packages =  with pkgs; [
     # to speed this up we would just have to get the path for all of the icons instead of searching
    (writeShellScriptBin "omnipicker" ''
        # I did try to make this dynamic - it was just too slow ):
        printed_items="img:/home/senyc/.nix-profile/share/icons/hicolor/scalable/apps/Alacritty.svg:text:Alacritty\nimg:/home/senyc/.nix-profile/share/icons/hicolor/128x128/apps/brave-browser.png:text:Brave\nimg:/home/senyc/.nix-profile/share/icons/hicolor/128x128/apps/spotify-client.png:text:Spotify\nimg:/home/senyc/.nix-profile/share/pixmaps/slack.png:text:Slack\nimg:/home/senyc/.nix-profile/share/icons/hicolor/128x128/apps/nvim.png:text:Nvim\nimg:${./icons/logseq.png}:text:Logseq"

        case "$(echo -e $printed_items | ${wofi}/bin/wofi)" in
            *"Alacritty"*)
                alacritty &
                ;;
            *"Slack"*)
                if pgrep slack; then
                    hyprctl dispatch workspace 4 
                else 
                    slack &
                fi
                ;;
            *"Nvim"*)
                hyprctl dispatch workspace 1
                ;;
            *"Spotify"*)
                if pgrep spotify; then
                    hyprctl dispatch workspace 3 
                else 
                    spotify &
                fi
                ;;
            *"Brave"*)
                brave &
                ;;
            *"Logseq"*)
                if pgrep -f logseq; then
                    hyprctl dispatch workspace 5 
                else 
                    logseq &
                fi
                ;;
            default)
            ;;
        esac
    '')
    ];
  };
}
