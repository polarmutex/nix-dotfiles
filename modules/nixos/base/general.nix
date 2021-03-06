{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.polar.base.general;
in
{

  ###### interface
  options = {

    polar.base.general = {
      enable = mkEnableOption "basic config" // { default = true; };

      hostname = mkOption {
        type = types.enum [ "polarbear" "blackbear" "polarvortex" ];
        description = "Host name.";
      };

      doas_persist = mkEnableOption "doas persist" // { default = true; };

    };

  };


  ###### implementation
  config = mkIf cfg.enable {

    boot.cleanTmpDir = true;

    environment = {
      systemPackages = with pkgs; [
        binutils
        coreutils
        curl
        dnsutils
        fd
        gh
        git
        git-crypt
        gnumake
        gnupg
        htop
        moreutils
        neovim
        nix-index
        nmap
        ripgrep
        rsync
        tmux
        wget
        whois
        usbutils
        utillinux
      ];
    };

    networking = {
      hostName = cfg.hostname;
      usePredictableInterfaceNames = false;
    };

    nix = {
      settings.auto-optimise-store = true;

      settings.substituters = [
        "https://cache.nixos.org"
        "https://cachix.cachix.org"
        "https://polarmutex.cachix.org"
        "http://nix-community.cachix.org"
      ];
      settings.trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
        "polarmutex.cachix.org-1:kUFH4ftZAlTrKlfFaKfdhKElKnvynBMOg77XRL2pc08="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      gc = {
        automatic = true;
        dates = "hourly";
        options = "--delete-older-than 7d";
      };

      optimise = {
        automatic = true;
        dates = [ "daily" ];
      };

      daemonCPUSchedPolicy = lib.mkDefault "idle";
      daemonIOSchedPriority = lib.mkDefault 7;

      settings.trusted-users = [ "root" "polar" ];

      # TODO  what is difference between this and nixFlakes
      package = pkgs.nixFlakes;

      extraOptions = ''
        experimental-features = nix-command flakes
      '';

    };

    security = {
      #protectKernelImage = lib.mkDefault true;
      sudo.enable = false;
      doas = {
        enable = true;
        wheelNeedsPassword = false;
        extraRules = [
          {
            groups = [ "wheel" ];
            persist = true;
          }
          {
            users = [ "polar" ];
            noPass = true;
            runAs = "root";
          }
        ];
      };
      wrappers.sudo = {
        setuid = true;
        owner = "root";
        group = "root";
        source = "${pkgs.doas}/bin/doas";
      };
    };

    programs.zsh = {
      enable = true;
      enableGlobalCompInit = false;
      promptInit = "";
    };

    system.stateVersion = "21.05";

    time.timeZone = "America/New_York";

    i18n = {
      defaultLocale = "en_US.UTF-8";
    };

    users.users = {
      root.shell = pkgs.zsh;

      polar = {
        uid = 1000;
        extraGroups = [ "wheel" ];
        isNormalUser = true;
        shell = pkgs.zsh;
      };
    };

  };

}
