{ config, lib, ... }:

with lib;

let
  cfg = config.polar.services.openssh;
in

{

  ###### interface

  options = {

    polar.services.openssh = {
      enable = mkEnableOption "openssh";

      rootLogin = mkEnableOption "root login via pubkey";

      forwardX11 = mkEnableOption "x11 forwarding";
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    services.openssh = {
      inherit (cfg) forwardX11;
      enable = true;
      #openFirewall = true;
      permitRootLogin = "no"; #mkIf (!cfg.rootLogin) "no";
      passwordAuthentication = true; #TODOfalse;
      #extraConfig = "MaxAuthTries 3";
    };

    users.users = {
      root.openssh.authorizedKeys.keyFiles = [
        (builtins.fetchurl {
          url = "https://github.com/polarmutex.keys";
          sha256 = "sha256:1083pj4mb4lndcfa4s0wykgn67y0ampfz9f4nivivlq0549h2kq1";
        })
      ];
      polar.openssh.authorizedKeys.keyFiles = [
        (builtins.fetchurl {
          url = "https://github.com/polarmutex.keys";
          sha256 = "sha256:1083pj4mb4lndcfa4s0wykgn67y0ampfz9f4nivivlq0549h2kq1";
        })
      ];
    };

  };

}
