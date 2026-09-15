{
  description = "Antigravity 2.0 CLI - Google's next-generation development tool";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        
        # Platform mapping for Antigravity manifests
        platformMap = {
          "x86_64-linux" = "linux_amd64";
          "aarch64-linux" = "linux_arm64";
          "x86_64-darwin" = "darwin_amd64";
          "aarch64-darwin" = "darwin_arm64";
        };
        
        platform = platformMap.${system} or (throw "Unsupported system: ${system}");
        
        # Fetch version info from Antigravity's manifest
        manifestUrl = "https://antigravity-cli-auto-updater-974169037036.us-central1.run.app/manifests/${platform}.json";
        
        # Version metadata (updated automatically by CI)
        version = "1.2.3";
        
        # Platform-specific hashes (updated automatically by CI)
        hashes = {
          "x86_64-linux" = "sha512-7HTcXOIOZGI6TWjnOolX5GjAJr2z0HsVxSkUkDIxM5cMc12YWvg56rBXtSsb/Rsukf9Jq+6+8DL/rm3e2OKnYw==";
          "aarch64-linux" = "sha512-vasbzdT+p56uZjI5oG6OeWTZkF7G+gcgdmRPdQbHznPPLrhWPrcGA2a9torYFeX8W93zirYh85r/V2qQiZo6xg==";
          "x86_64-darwin" = "sha512-QFXe0JErhwU1bYLoFe81m2aqb6Mf8vlJS/CTFFjrf2XReiZNPP+ncHABvunBCpenT5UfVnYgSyhnFuOcVDsfoQ==";
          "aarch64-darwin" = "sha512-nQtuiRlg3f98Gi1TKgjqslte69HklTQj8aVkwmFk7iK09OJ6FB/jH5WCf1kk4EpK6hBCIwXh3dk3T0v/USTZlg==";
        };
        
        hash = hashes.${system} or (throw "No hash available for system: ${system}");
        
      in
      {
        packages = {
          default = self.packages.${system}.antigravity;
          
          antigravity = pkgs.stdenv.mkDerivation {
            pname = "antigravity";
            inherit version;

            src = pkgs.fetchurl {
              url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/${version}-5288553236791296/linux-x64/cli_linux_x64.tar.gz";
              inherit hash;
            };

            nativeBuildInputs = [ pkgs.autoPatchelfHook ];
            
            buildInputs = [
              pkgs.stdenv.cc.cc.lib
            ];

            sourceRoot = ".";

            installPhase = ''
              runHook preInstall
              
              mkdir -p $out/bin
              install -m755 antigravity $out/bin/antigravity
              
              runHook postInstall
            '';

            meta = with pkgs.lib; {
              description = "Antigravity 2.0 CLI - Google's next-generation development tool";
              homepage = "https://antigravity.google";
              license = licenses.unfree;
              platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
              maintainers = [ ];
            };
          };
        };

        # Development shell with antigravity available
        devShells.default = pkgs.mkShell {
          buildInputs = [ self.packages.${system}.antigravity ];
          
          shellHook = ''
            echo "Antigravity ${version} development environment"
            echo "Run 'antigravity --help' to get started"
          '';
        };

        # Apps for easy execution
        apps.default = {
          type = "app";
          program = "${self.packages.${system}.antigravity}/bin/antigravity";
        };
      }
    );
}
