{inputs, ...}: {
  perSystem = {
    pkgs,
    inputs',
    lib,
    ...
  }: let
    qmlPath = with pkgs.kdePackages;
      lib.makeSearchPath "lib/qt-6/qml" [
        qt5compat
        qtpositioning
        syntax-highlighting
        kirigami.unwrapped
      ];
  in {
    packages.shell = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = inputs'.quickshell.packages.default;

      runtimeInputs = [
        # empty for now :D...
      ];

      env = {
        QML2_IMPORT_PATH = "${qmlPath}";
      };

      flags = {
        "-p" = "${inputs.illogical-impulse}/dots/.config/quickshell/ii";
      };
    };
  };
}
