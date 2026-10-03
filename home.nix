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
    # 核心修复 1：显示指定 Portal 的全局配置文件，通知 xdg-desktop-portal 使用 gtk 后端
    "xdg-desktop-portal/portals.conf".text = ''
      [preferred]
      default=gtk
    '';
  };

  # xdg.dataFile = {
  #   # scripts here will apear under ~/.local/share/
  # };

  home.packages = with pkgs; [
    fastfetch # for fetching system specs
    ripgrep
    nil
    nixpkgs-fmt
    nodejs # for some of the neovim stuff
    gcc # for compiling some of the neovim tree-sitter
    unzip # for some of the neovim mason-lsp building process
    unrar
    p7zip
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
    gnome-clocks
    vlc
    darkman
    dconf
    glib # 提供 gsettings
    xdg-desktop-portal
    xdg-desktop-portal-gtk # 关键！Chrome 靠它来获取配色
    hugo
  ];

# 启用 Darkman 并改用底层 dconf 写入（避免 gsettings schemas 丢失）
  services.darkman = {
    enable = true;
    
    settings = {
      lat = 31.23;
      lng = 121.47;
      usegeoclue = false;
    };

    darkModeScripts = {
      switch-gtk-theme = ''
        ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
        ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/gtk-theme "'Adwaita-dark'"
        # ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
        # ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
        ${pkgs.libnotify}/bin/notify-send "Theme" "Switched to Dark Mode"
      '';
    };

    lightModeScripts = {
      switch-gtk-theme = ''
        ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
        ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/gtk-theme "'Adwaita'"
        # ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
        # ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'
        ${pkgs.libnotify}/bin/notify-send "Theme" "Switched to Light Mode"
      '';
    };
  };

  # 1. 必须开启 dconf，否则 gsettings 修改无法通过 dbus 广播
  dconf.enable = true;

  # 3. 开启 XDG Portal 服务
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    # 强制让 appearance/settings 使用 gtk portal
    config.common = {
      default = [ "gtk" ];
    };
  };

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

    theme = {
      name = "Adwaita";
      package = pkgs.gnome-themes-extra; # 确保 Adwaita-dark 主题包安装完整
    };
  };

  # catppuccin.enable = true;
}
