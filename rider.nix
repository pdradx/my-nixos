{ config, pkgs, ... }: 
let
  dotnet-sdks = pkgs.dotnetCorePackages.combinePackages [
    pkgs.dotnet-sdk_8
    pkgs.dotnet-sdk_9
    pkgs.dotnet-sdk_10
  ];
in {
  nixpkgs.overlays = [
    (final: prev: {
      jetbrains = prev.jetbrains // {
	rider = prev.jetbrains.rider.overrideAttrs (old: rec {
	  #buildInputs = (old.buildInputs or []) ++ (with pkgs; [ dotnet-sdks ]);
	  #nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ pkgs.makeWrapper ];

	  name = "rider-${version}";
	  version = "2025.3.3";
	  src = prev.fetchurl {
	    url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}.tar.gz";
	    sha256 = "sBF/XA52oSFD1dEmzhvo7cwf5EGTi0mx1x3PcobQVAs=";
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
  ];

  environment.systemPackages = with pkgs; [
    jetbrains.rider
  ];
}
