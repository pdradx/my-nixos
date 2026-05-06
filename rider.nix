{ config, pkgs, pkgs-unstable, ... }: 
let
  dotnet-sdks = pkgs.dotnetCorePackages.combinePackages [
    pkgs.dotnet-sdk_8
    pkgs.dotnet-sdk_9
    pkgs.dotnet-sdk_10
  ];
  unstableRider = pkgs-unstable.jetbrains.rider.overrideAttrs (old: rec {
    name = "rider-${version}";
    version = "2026.1.1";
    src = pkgs-unstable.fetchurl {
      url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}.tar.gz";
      sha256 = "sha256-DjLN8vq0UDEmJKXEpLeuEjgmVWBeUKEo6471FJMPzCM=";
    };
  });
in {
  nixpkgs.overlays = [
    (final: prev: {
      jetbrains-rider-latest = unstableRider;
    })

    /*
    (final: prev: {
      jetbrains = prev.jetbrains // {
	rider_custom = prev.jetbrains.rider.overrideAttrs (old: rec {
	  #buildInputs = (old.buildInputs or []) ++ (with pkgs; [ dotnet-sdks ]);
	  #nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ pkgs.makeWrapper ];

	  #buildInputs = (old.buildInputs or []) ++ (with pkgs; [ 
	  #  libxcrypt
	  #  openssl_1_1
	  #]);

	  name = "rider-${version}";
	  version = "2026.1.1";
	  src = prev.fetchurl {
	    url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}.tar.gz";
	    sha256 = "sha256-DjLN8vq0UDEmJKXEpLeuEjgmVWBeUKEo6471FJMPzCM=";
	  };


	  #postInstall = (old.postInstall or "") + ''
	  #  mv $out/bin/rider $out/bin/.rider-wrapped
	  #  makeWrapper $out/bin/.rider-wrapped $out/bin/rider \
	  #    --prefix PATH : ${pkgs.msbuild}/bin
	  #'';

	  #    --set DOTNET_ROOT ${pkgs.dotnet-sdk_10} \
	  #    --prefix PATH : ${pkgs.dotnet-sdk_9}/bin \
	  #    --set DOTNET_ROOT ${pkgs.dotnet-sdk_9} 

	  #postInstall = (old.postInstall or "") + ''
	  #  mv $out/bin/rider $out/bin/.rider-wrapped
	  #  makeWrapper $out/bin/.rider-wrapped $out/bin/rider \
	  #    --prefix PATH : ${dotnet-sdks}/bin \
	  #    --set DOTNET_ROOT ${dotnet-sdks} 
	  #'';
	}
      );
    };
    })
    */
  ];

  environment.systemPackages = with pkgs; [
    jetbrains-rider-latest
  ];
}
