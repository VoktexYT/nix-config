{ pkgs, username, ... }:

let
     helix-theme = "gruvbox";

  colors = {
    bg      = "#282828";
    bg_hard = "#1d2021";
    fg      = "#ebdbb2";
    dark    = "#504945";
    gray    = "#928374";

    black   = "#282828";
    red     = "#cc241d";
    green   = "#98971a";
    yellow  = "#d79921";
    blue    = "#458588";
    magenta = "#b16286";
    cyan    = "#689d6a";
    white   = "#a89984";
    orange  = "#d65d0e";

    # Bright
    br_red     = "#fb4934";
    br_green   = "#b8bb26";
    br_yellow  = "#fabd2f";
    br_blue    = "#83a598";
    br_magenta = "#d3869b";
    br_cyan    = "#8ec07c";
    br_orange  = "#fe8019";
    # Sway
    focused = "#504945";
    text    = "#ffffff";
  };
  
  # Ta fonction pour Foot qui retire le #
  noHash = c: builtins.substring 1 6 c;
in
{
  # HOME MANAGER METADATA
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";

  ###############################
  # LAZYDOCKER
  ###############################
  programs.lazydocker = {
    enable = true;
    settings = {
      gui.theme = {
        activeBorderColor = [ "${colors.yellow}" "bold" ];
        inactiveBorderColor = [ "${colors.gray}" ];
        
        optionsTextColor = [ "${colors.blue}" ];
        selectedLineBgColor = [ "${colors.dark}" ];
        selectedRangeBgColor = [ "${colors.dark}" ];
        
        allBranchesLogGraphColor = [ "${colors.magenta}" ];
        defaultFgColor = [ "${colors.fg}" ];
      };
    };
  };

  ###############################
  # LAZYGIT
  ###############################
  programs.lazygit = {
    enable = true;
    settings = {
      gui.theme = {
        activeBorderColor = [ "${colors.yellow}" "bold" ];
        inactiveBorderColor = [ "${colors.gray}" ];
        searchingActiveBorderColor = [ "${colors.cyan}" "bold" ];
        
        optionsTextColor = [ "${colors.blue}" ];
        selectedLineBgColor = [ "${colors.dark}" ];
        selectedRangeBgColor = [ "${colors.dark}" ];
        cherryPickedCommitBgColor = [ "${colors.cyan}" ];
        cherryPickedCommitFgColor = [ "${colors.blue}" ];
        
        unstagedChangesColor = [ "${colors.red}" ];
        defaultFgColor = [ "${colors.fg}" ];
      };
    };
  };
  
  ###############################
  # TMUX
  ###############################
  programs.tmux = {
    enable = true;
    mouse = true;
    baseIndex = 1;
    escapeTime = 0;
    terminal = "foot";
    extraConfig = ''
      set -g mouse on
      set -g prefix M-Space
      unbind C-b

      bind M-Space set status-style bg=${colors.black},fg=${colors.white} \; send-prefix

      bind -n M-q kill-pane
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config Reloaded!"

      bind \\ split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R

      set -g status-style bg=${colors.black},fg=${colors.white}

      set -g window-status-current-format " #[bold,reverse] #I:#W #[none]"
      set -g window-status-format " #I:#W "

      set -g status-left ""
      set -g status-right " #(acpi | cut -d ',' -f 2 | tr -d ' ') | %H:%M "

      set -g pane-border-style fg=${colors.focused}
      set -g pane-active-border-style fg=${colors.orange}
    '';
  };

  ###############################
  # SWAY
  ###############################
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "foot";
      
      startup = [
        { command = "autotiling"; }
        { command = "foot"; }
      ];

      bars = [];

      window.border = 2;
      window.titlebar = false;

      gaps = {
        inner = 5;
        outer = 5;
        smartGaps = false;
      };

      colors = {
        focused = {
          border = "${colors.focused}";
          background = "${colors.focused}";
          text = "${colors.text}";
          indicator = "${colors.focused}";
          childBorder = "${colors.focused}";
        };
        focusedInactive = {
          border = "${colors.bg}";
          background = "${colors.bg}";
          text = "${colors.text}";
          indicator = "${colors.bg}";
          childBorder = "${colors.bg}";
        };
        unfocused = {
          border = "${colors.bg}";
          background = "${colors.bg}";
          text = "${colors.text}";
          indicator = "${colors.bg}";
          childBorder = "${colors.bg}";
        };
      };

      output = {
        "*" = { bg = "${colors.bg_hard} solid_color"; };
      };

      keybindings = let
        mod = "Mod4";
      in {
        "${mod}+Return" = "exec foot";
        "${mod}+w" = "exec firefox";
        "${mod}+s" = "exec grim -g \"$(slurp)\" - | wl-copy";
        "${mod}+q" = "kill";

        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";

        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";

        "${mod}+Mod1+h" = "move left 20px";
        "${mod}+Mod1+j" = "move down 20px";
        "${mod}+Mod1+k" = "move up 20px";
        "${mod}+Mod1+l" = "move right 20px";

        "${mod}+Control+h" = "resize shrink width 10 px";
        "${mod}+Control+j" = "resize grow height 10 px";
        "${mod}+Control+k" = "resize shrink height 10 px";
        "${mod}+Control+l" = "resize grow width 10 px";

        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";

        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";
      };
    };
  };

  ###############################
  # FOOT
  ###############################
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=16";
        pad = "10x10";
        shell = "${pkgs.tmux}/bin/tmux";
      };
      colors = {
        foreground = noHash colors.fg;
        background = noHash colors.bg;

        regular0 = noHash colors.black;
        regular1 = noHash colors.red;
        regular2 = noHash colors.green;
        regular3 = noHash colors.yellow;
        regular4 = noHash colors.blue;
        regular5 = noHash colors.magenta;
        regular6 = noHash colors.cyan;
        regular7 = noHash colors.white;

        bright0 = noHash colors.gray;
        bright1 = noHash colors.br_red;
        bright2 = noHash colors.br_green;
        bright3 = noHash colors.br_yellow;
        bright4 = noHash colors.br_blue;
        bright5 = noHash colors.br_magenta;
        bright6 = noHash colors.br_cyan;
        bright7 = noHash colors.fg;
      };
    };
  };

  ###############################
  # HELIX
  ###############################
  programs.helix = {
    enable = true;
    settings = {
      theme = helix-theme;
      editor = {
        line-number = "absolute";
        cursorline = true;
        color-modes = true;
        true-color = true;
        scrolloff = 3;
        clipboard-provider = "wayland";
        auto-format = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        file-picker = { hidden = false; };
        statusline = {
          mode.normal = "NORMAL";
          mode.insert = "INSERT";
          mode.select = "SELECT";
        };
        indent-guides = {
          render = true;
          character = ":";
        };
        lsp = {
          display-inlay-hints = true;
          display-messages = true;
        };
      };
      keys.normal = {
        "y" = [ "yank" "yank_main_selection_to_clipboard" ];
        "p" = [ "paste_clipboard_after" ];
      };
    };

    languages = {
      language-server = {
        vtsls = {
          command = "vtsls";
          args = ["--stdio"];
          config.typescript.updateImportsOnFileMove.enabled = "always";
        };

        tailwindcss-ls = {
          command = "tailwindcss-language-server";
          args = ["--stdio"];
        };

        eslint = {
          command = "vscode-eslint-language-server";
          args = ["--stdio"];
        };

        nixd = { command = "nixd"; };

        intelephense = {
          command = "intelephense";
          args = ["--stdio"];
          config = { storagePath = "/tmp/intelephense"; };
        };

        phpactor = {
          command = "phpactor";
          args = ["language-server"];
        };

        sqls = { command = "sqls"; };
      };

      language = [
        {
          name = "typescript";
          language-servers = [ { name = "vtsls"; } "tailwindcss-ls" "eslint" ];
          formatter = { command = "prettier"; args = ["--parser" "typescript"]; };
          auto-format = true;
        }

        {
          name = "tsx";
          language-servers = [ { name = "vtsls"; } "tailwindcss-ls" "eslint" ];
          formatter = { command = "prettier"; args = ["--parser" "typescript"]; };
          auto-format = true;
        }

        {
          name = "html";
          formatter = { command = "prettier"; args = ["--parser" "html"]; };
          auto-format = true;
        }

        {
          name = "css";
          formatter = { command = "prettier"; args = ["--parser" "css"]; };
          auto-format = true;
        }

        {
          name = "scss";
          formatter = { command = "prettier"; args = ["--parser" "scss"]; };
          auto-format = true;
        }

        {
          name = "nix";
          language-servers = [ "nixd" ];
          formatter = { command = "nixpkgs-fmt"; };
          auto-format = true;
        }

        {
          name = "python";
          language-servers = [ "jedi-language-server" "ruff" ];
          formatter = { command = "ruff"; args = ["format" "-"]; };
          auto-format = true;
        }

        {
          name = "sql";
          language-servers = [ "sqls" ];
          formatter = { command = "sqlfluff"; args = ["format" "-" "--dialect" "mysql"]; };
          auto-format = true;
        }

        {
          name = "php";
          language-servers = [ "intelephense" "phpactor" ];
          formatter = { command = "php-cs-fixer"; args = ["fix" "-" "--rules=@PSR12"]; };
          auto-format = true;
        }
      ];
    };
  }; 

  ###############################
  # GIT
  ###############################
  programs.git = {
    enable = true;
    settings.user = {
      name = "VoktexYT";
      email = "ubguertin@gmail.com";
    };
  };
}
