{ inputs, pkgs, lib, config, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./persist.nix
  ];

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: { inherit flake; })) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = [ "/etc/nix/path" ];

  environment.etc =
    lib.mapAttrs'
      (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      })
      config.nix.registry;

  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  networking.hostName = "zephyrus";
  networking.networkmanager.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/Chicago";

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.mutableUsers = false;

  users.users = {
    root.initialHashedPassword = "$y$j9T$VPc2FfxR./bV/3fD4UE05/$dSMNRe5O5Y0RJGA.MQ36dHXl/GnKNkBS8Tknb2sNIO0";

    arakhor = {
      initialHashedPassword = "$y$j9T$VPc2FfxR./bV/3fD4UE05/$dSMNRe5O5Y0RJGA.MQ36dHXl/GnKNkBS8Tknb2sNIO0";
      extraGroups = [ "wheel" ];
      isNormalUser = true;
      shell = pkgs.zsh;
    };
  };

  programs.zsh.enable = true;

  # Enables copy / paste when running in a KVM with spice.
  services.spice-vdagentd.enable = true;

  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };

  fonts.packages = with pkgs; [
    fira-mono
    hack-font
    inconsolata
    iosevka
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
