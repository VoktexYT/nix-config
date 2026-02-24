{  pkgs, unstable, inputs, username, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.home-manager
    ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Toronto";
  hardware.graphics.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "docker" "wheel" "adbusers" "kvm" "libvirtd" ]; 
    shell = pkgs.fish;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;

  programs.sway.enable = true;
  programs.ssh.startAgent = true;  

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  }; 
  
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set fish_greeting
    '';

    promptInit = ''
      function fish_prompt
        set_color brgrey
        
        printf '%s $ ' (prompt_pwd)
        
        set_color normal
      end
    '';

    shellAbbrs = {
      cd = "z";
      lgit = "lazygit";
      ldocker = "lazydocker";
      cls = "clear";
      c = "clear";
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#${username}";
      ls = "eza";
      cat = "bat";
    };
  };

  environment.systemPackages = with pkgs; [    
    ### SOFTWARES
    foot
    firefox
    helix
    nnn

    ### TOOLS
    git
    unstable.kiro-cli
    lazygit
    lazydocker
    bun
    python3
    
    ### SCREENSHOT
    grim
    slurp    
    
    ## SYSTEM
    fastfetch
    autotiling
    eza
    bat

    ### COPY-PAST
    wl-clipboard

    ### TMUX SETUP ###
    acpi
    tmux
    
    ### HELIX LSP

    #// HTML5, CSS3, SCSS, JSON, TSX, JSX
    nodePackages.prettier
    vtsls
    tailwindcss-language-server

    #// Typescript, Javascript
    nodePackages.vscode-langservers-extracted

    #// nix
    nixd
    
    #// Python
    ruff
    python3Packages.jedi-language-server

    #// SQL
    sqls
    sqlfluff

    #// PHP
    phpactor
    nodePackages.intelephense
    php83Packages.php-cs-fixer
  ];

  ###
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
    ];
  };


  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit username; };
    users.${username} = import ./home-config.nix;
  };

  services.dbus.enable = true;
  services.openssh.enable = true;

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --user-menu --asterisks --cmd \"dbus-run-session sway\"";
      user = "greeter";
    };
  };
  
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11";
}

