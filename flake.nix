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
        version = "1.1.17";
        
        # Platform-specific hashes (updated automatically by CI)
        hashes = {
          "x86_64-linux" = "sha512-XGBHoZ6AAl6nzsyBUvsmOn8U6AWR7nW98coQGRzAzRY5tbXr3OTRydQ7FL0kRvA4pFeCFpRXn0OStsqXNlEpNg==";
          "aarch64-linux" = "sha512-rYcVOPyLvQz5bhG4XjiNrd5c0CFkwpIc980wZG40PJCmPvUiT2QgYSrW+R/gbyYOMy4weWgILzofVOU5M76Efw==";
          "x86_64-darwin" = "sha512-OMI/6/Z3yTumLMzJec7uA0jnM+LR2CfJ0HUUIuXURitd8QMP+X8H14owGUzBOGprQouj+FFBpl9XLoBKmXi9pQ==";
          "aarch64-darwin" = "sha512-7aF+nzZJ3xK81hTiJpg5Is1eTCKpFT6fml7MVVet3NoPAxR9uKLGwZ2uuOHcgGKpobz4YoQxXCsarnPy2CNrHg==";
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
