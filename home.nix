{ config, pkgs, catppuccin, ... }:
let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    nvim = "nvim";
    alacritty = "alacritty";
    wal = "wal";
    hypr = "hypr";
    pypr = "pypr";
    waybar = "waybar";
    rofi = "rofi";
    kitty = "kitty";
    wlogout = "wlogout";
    i3 = "i3";
  };
in

{

  imports = 
    [
      ./modules/suckless.nix
      ./modules/wallpaper.nix
      ./modules/statusbar.nix
      ./modules/notification.nix
      ./modules/picom.nix
    ];

  home.username = "light";
  home.homeDirectory = "/home/light";

  services.polkit-gnome.enable = true;
  systemd.user.services.polkit-gnome = {
    Unit = {
      Description = "GNOME PolicyKit Agent";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      Environment = [ "DISPLAY=:0" ];   # 如果是 X11 可以加，Wayland 通常不需要
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

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

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    initContent = ''
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      (cat ~/.cache/wal/sequences &)
    '';
  };

  xdg.configFile = (builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs) // {
    "kdeglobals".text = ''
      [General]
      TerminalApplication=kitty
      TerminalService=kitty.desktop
    '';
  };

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
    lua-language-server
    clang-tools
    bash-language-server
    typescript-language-server
    stylua
    shellcheck
    scrot
    xclip
    dunst
    zsh-powerlevel10k
    imagemagick
    ranger
    pywal16
    btop
    cava
    google-chrome
    spotify
    tldr
    telegram-desktop
    nwjs
  ];

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.apple-cursor;
    name = "macOS";
    size = 16;
  };

  gtk = {
    enable = true;
  
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  # catppuccin.enable = true;
}
