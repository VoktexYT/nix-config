{  pkgs, unstable, inputs, username, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = { automatic = true; dates = "daily"; options = "--delete-older-than 7d"; };
  
  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 5;
    efi.canTouchEfiVariables = true;
    timeout = 0;
  };

  virtualisation.docker.enable = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "America/Toronto";

  hardware.graphics.enable = true;
  hardware.bluetooth = { enable = true; powerOnBoot = true; };
  
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "docker" "wheel" "adbusers" "kvm" "libvirtd" "video" ]; 
    shell = pkgs.fish;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  programs.fish.enable = true;
  programs.sway.enable = true;
  programs.zoxide.enable = true;
  programs.light.enable = true;
  services.k3s.enable = true;
  services.k3s.role = "server";
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  environment.systemPackages = with pkgs; [    
    git    
    helix
    wl-clipboard
    k9s
    kind
    kubectl
    kubernetes-helm
  ];

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --user-menu --asterisks --cmd \"dbus-run-session sway\"";
      user = "greeter";
    };
  };
  
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit username unstable; };
    users.${username} = import ./home-config.nix;
  };

  system.stateVersion = "25.11";
}

