{ config, pkgs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    nvim = "nvim";
    alacritty = "alacritty";
  };
in

{

  imports = 
    [
      ./modules/suckless.nix
      ./modules/wallpaper.nix
      ./modules/statusbar.nix
    ];

  home.username = "light";
  home.homeDirectory = "/home/light";
  programs.git = {
    enable = true;
    settings.user = {
      name = "lightmon";
      email = "lightmon5210@outlook.com";
    };
  };
  home.stateVersion = "26.05";
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo I use nixos, btw";
    };
  };

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) 
  configs;

  # xdg.configFile."nvim" = {
  #   source = create_symlink "${dotfiles}/nvim/";  
  #   recursive = true;
  # };

  home.packages = with pkgs; [
    fastfetch # for fetching system specs
    ripgrep
    nil
    nixpkgs-fmt
    nodejs # for some of the neovim stuff
    gcc # for compiling some of the neovim tree-sitter
    unzip # for some of the neovim mason-lsp building process
    tree-sitter # for neovim tree-sitter
    neovim
    scrot
    xclip
    dunst
  ];
}
