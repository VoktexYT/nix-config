{  pkgs, unstable, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Toronto";
  hardware.graphics.enable = true;

  users.users.voktex = {
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
    nodejs_22
    phpactor
    vtsls
    nodePackages.typescript
    nodePackages.vscode-langservers-extracted
  ];

  ###
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
    ];
  };


  programs.bash.promptInit = ''
    export PS1="\[\033[0;90m\]\w \$ \[\033[0m\]"

    alias lgit="lazygit"
    alias ldocker="lazydocker"
    alias d="docker"

    alias rebuild="sudo nixos-rebuild switch --flake /etc/nixos#voktex"
  '';

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

