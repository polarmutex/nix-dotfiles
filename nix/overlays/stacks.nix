final: prev: {
  stacks = final.appimageTools.wrapType2 rec{
    pname = "stacks-task-manager";
    version = "1.9.7";

    src = final.lib.fetchurl {
      url = "https://github.com/stacks-task-manager/stacks/releases/download/v${version}/Stacks-Linux-${version}.AppImage";
      sha256 = "sha256-TN49SSO+98kBjtpU3unh8UT+uPUDw9yn65/fBmCMdhA=";
    };

    profile = ''
      export XDG_DATA_DIRS=${prev.gsettings-desktop-schemas}/share/gsettings-schemas/${prev.gsettings-desktop-schemas.name}:${prev.gtk3}/share/gsettings-schemas/${prev.gtk3.name}:$XDG_DATA_DIRS
    '';

    meta = with prev.lib; {
      description = "Your personal kanban to do and project manager";
      homepage = "https://github.com/stacks-task-manager/stacks";
      #license = licenses.none;
      maintainers = with maintainers; [ polarmutex ];
      platforms = [ "x86_64-linux" ];
    };

  };
}
