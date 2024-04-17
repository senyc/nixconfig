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
        show="drun";
        width="30%";
        lines=6;
        line_wrap="word";
        term="alacritty";
        allow_markup=true;
        always_parse_args=false;
        show_all=true;
        print_command=true;
        layer="overlay";
        allow_images=true;
        sort_order="alphabetical";
        gtk_dark=true;
        prompt="";
        image_size=20;
        display_generic=false;
        location="center";
        key_expand="Tab";
        insensitive="false";
      };
      style = ''
        * {
          font-family: JetBrainsMono;
          color: #e5e9f0;
          background: transparent;
        }

        #window {
          background: rgba(41, 46, 66, 0.5);
          margin: auto;
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

        #input:focused {
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
  };
}
