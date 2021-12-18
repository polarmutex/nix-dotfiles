{ config, suites, pkgs, lib, ... }:
{
  imports = suites.base ++ [ ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;

  boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "ehci_pci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

  swapDevices = [
    { device = "/dev/disk/by-label/swap"; }
  ];

  hardware = {
    nvidia = {
      modesetting.enable = false;
      prime = {
        offload.enable = false;
      };
    };
  };
  #virtualisation.virtualbox.guest.enable = true;

  system.stateVersion = " 21.05 ";
}



