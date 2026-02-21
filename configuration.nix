{  pkgs, unstable, inputs, username, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.home-manager
    ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Toronto";
  hardware.graphics.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "docker" "wheel" "adbusers" "kvm" "libvirtd" ]; 
    shell = pkgs.bash;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;

  programs.sway.enable = true;
  programs.ssh.startAgent = true;  
  programs.zoxide.enable = true;  

  environment.systemPackages = with pkgs; [    
    ### SOFTWARES
    foot
    firefox
    autotiling

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
    helix

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

