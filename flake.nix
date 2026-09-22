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
        version = "1.2.7";
        
        # Platform-specific hashes (updated automatically by CI)
        hashes = {
          "x86_64-linux" = "sha512-/sdp1hHEr98K5y04vbJlLI4sjnHk9t6XonuA3aPFBCkWDZ4Dd2o2pZuIV8IOdng8SknLD+uLL1w7+SWwzAO7dw==";
          "aarch64-linux" = "sha512-05+Tn/yAd2v9LcENt7mhobWGUPCBFfohBlwR0QiCxxIQ82jC5gYPJpZtGjPWst0rwZv9ZBBiMFr2VGxR1JRRGg==";
          "x86_64-darwin" = "sha512-SycaUzLmhBYIGl/M3AfF7aQu5+lkxG/Ju+xej50fv9N+65lThVzAgPmj7/hQuvqcsD95gPHwsc3Tx/lAKXKx8A==";
          "aarch64-darwin" = "sha512-4mAyzkIJhaGOcgtuwcCdg2Cu2FHT4zRRSMmgUreRiYmlK2LdLI20U1meo0G4spcgc3hG/9N92caLa8bs5KBZlA==";
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
