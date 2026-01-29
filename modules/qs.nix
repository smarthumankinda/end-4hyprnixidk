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

    fontConfig = pkgs.makeFontsConf {
      fontDirectories = with pkgs; [
        material-symbols
        (
          pkgs.stdenvNoCC.mkDerivation {
            pname = "google-sans-flex";
            version = "unstable";

            src = pkgs.fetchFromGitHub {
              owner = "end-4";
              repo = "google-sans-flex";
              rev = "main";
              sha256 = "sha256-HMAS0L/Tsqyl1xI16cyIzg9LEb6Dyq91JY4wqFQV9Vs=";
            };

            dontBuild = true;

            installPhase = ''
              runHook preInstall
              install -Dm644 *.ttf \
                -t $out/share/fonts/truetype/illogical-impulse-google-sans-flex
              runHook postInstall
            '';
          }
        )
      ];
    };
  in {
    packages.shell = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = inputs'.quickshell.packages.default;

      runtimeInputs = [
        # empty for now :D...
      ];

      env = {
        QML2_IMPORT_PATH = "${qmlPath}";
        FONTCONFIG_FILE = "${fontConfig}";
      };

      flags = {
        "-p" = "${inputs.illogical-impulse}/dots/.config/quickshell/ii";
      };
    };
  };
}
