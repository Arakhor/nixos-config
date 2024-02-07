{ pkgs, ... }: {
  home = {
    username = "arakhor";
    homeDirectory = "/home/arakhor";
  };

  home.packages = with pkgs; [ xclip tree ripgrep ];

  programs = {
    home-manager.enable = true;
    git.enable = true;

    alacritty.enable = true;
    fzf.enable = true; # enables zsh integration by default
    starship.enable = true;

    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
    };

    neovim = {
      enable = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
