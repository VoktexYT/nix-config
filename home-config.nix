{ pkgs, unstable, username, ... }:

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

    br_red     = "#fb4934";
    br_green   = "#b8bb26";
    br_yellow  = "#fabd2f";
    br_blue    = "#83a598";
    br_magenta = "#d3869b";
    br_cyan    = "#8ec07c";
    br_orange  = "#fe8019";

    focused = "#504945";
    text    = "#ffffff";
  };
  
  noHash = c: builtins.substring 1 6 c;
  gitEmail = "...";
  gitName = "Ubert Guertin"; 
in
{
  home.stateVersion = "25.11";

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 15;
  };

  home.packages = with pkgs; [
    # Softwares
    foot brave obsidian trash-cli

    # Dev & Tools
    bun python3 php82 php82Packages.composer
    unstable.kiro-cli lazygit lazydocker nnn btop httpie circumflex
    ripgrep fd sd fzf fastfetch eza bat

    # Screenshots
    grim slurp
  
    # LSPs
    marksman vtsls tailwindcss-language-server nodePackages.prettier
    nodePackages.vscode-langservers-extracted nixd ruff python3Packages.jedi-language-server
    sqls sqlfluff phpactor nodePackages.intelephense php83Packages.php-cs-fixer

    # System essentials
    wl-clipboard acpi autotiling
  ];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      direnv hook fish | source
    '';
  
    shellInit = ''
      set -gx EDITOR hx    
      set -gx VISUAL hx
      set -gx NNN_TRASH 1
      set -gx NNN_OPTS e
      set -gx OLLAMA_API_BASE http://localhost:11434
    '';

    shellAbbrs = {
      cat = "bat"; cd = "z"; lgit = "lazygit"; ldocker = "lazydocker"; c = "clear";
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#${username}";
      off = "shutdown now"; shx = "sudo -E hx";
      ls = "eza --icons --group-directories-first";  
      l = "eza -lh --icons --git --group-directories-first";  
      la = "eza -lah --icons --git";
    };

    functions = {
      fish_prompt = {
        body = ''
          set_color brgrey        
          printf '\n%s $ ' (prompt_pwd)
          set_color normal
        '';
      };
    };
  };

  programs.helix = {
    enable = true;
    settings = {
      theme = helix-theme;
      editor = {
        line-number = "relative";
        scrolloff = 5;
        cursorline = false;
        auto-format = true;
        idle-timeout = 50;
        completion-trigger-len = 1;
        indent-guides.render = false;
        statusline = {
          left = ["mode"];
          center = ["file-name"];
          right = [];
          mode.normal = " ";
          mode.insert = "i";
        };
      };
      keys.normal = {
        "y" = [ "yank" "yank_main_selection_to_clipboard" ];
        "p" = [ "paste_clipboard_after" ];
        "C-h" = ":bp"; "C-l" = ":bn"; "C-q" = ":bc";
        "C-j" = ["extend_to_line_bounds" "delete_selection" "paste_after"];
        "C-k" = ["extend_to_line_bounds" "delete_selection" "move_line_up" "paste_before"];
        space = { f = "file_picker"; q = ":q!"; s = ":wq"; };
      };
      keys.insert = { "A-j" = "normal_mode"; };
    };

    languages = import ./helix-languages.nix { inherit pkgs; }; 
  };

  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "foot";

      input = {
        "*" = {
          xkb_layout = "us,ca";
          xkb_options = "grp:win_space_toggle";
        };
      };

      startup = [
        { command = "autotiling"; }
        { command = "foot"; }
      ];

      bars = [];
      
      window = { border = 0; titlebar = false; };

      gaps = { inner = 0; outer = 0; smartGaps = false; };
      
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
        "XF86MonBrightnessUp" = "exec light -A 5";
        "XF86MonBrightnessDown" = "exec light -U 5";

        "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
        "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

        "${mod}+Return" = "exec foot";

        "${mod}+q" = "kill";
        "${mod}+w" = "exec brave";
        "${mod}+s" = "exec grim -g \"$(slurp)\" - | wl-copy";

        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";

        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";

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

  programs.git = {
    enable = true;
    settings.user = {
      name = gitName;
      email = gitEmail;
    };
  };

  programs.foot = {
    enable = true;
    settings = {
      main = { font = "JetBrainsMono Nerd Font:size=16"; shell = "${pkgs.tmux}/bin/tmux"; };
      colors = {
        foreground = noHash colors.fg; background = noHash colors.bg;
        regular0 = noHash colors.black; regular1 = noHash colors.red;
        regular2 = noHash colors.green; regular3 = noHash colors.yellow;
        regular4 = noHash colors.blue; regular5 = noHash colors.magenta;
        regular6 = noHash colors.cyan; regular7 = noHash colors.white;
        bright0 = noHash colors.gray; bright1 = noHash colors.br_red;
        bright2 = noHash colors.br_green; bright3 = noHash colors.br_yellow;
        bright4 = noHash colors.br_blue; bright5 = noHash colors.br_magenta;
        bright6 = noHash colors.br_cyan; bright7 = noHash colors.fg;
      };
    };
  };

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
      unbind q
      unbind Q

      bind M-Space set status-style bg=${colors.black},fg=${colors.white} \; send-prefix
      bind q kill-pane
      bind Q kill-window
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config Reloaded!"
      bind \\ split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R
      bind -n M-H resize-pane -L 5
      bind -n M-J resize-pane -D 2
      bind -n M-K resize-pane -U 2
      bind -n M-L resize-pane -R 5
      bind D split-window -h -p 30 \; split-window -v -p 50 \; select-pane -L

      set -g status-style bg=${colors.black},fg=${colors.white}
      set -g window-status-current-format " #[bold,reverse] #I:#W #[none]"
      set -g window-status-format " #I:#W "
      set -g status-left ""
      set -g status-right " #(acpi | cut -d ',' -f 2 | tr -d ' ') | %H:%M "
      set -g pane-border-style fg=${colors.focused}
      set -g pane-active-border-style fg=${colors.orange}
    '';
  };
  
}
