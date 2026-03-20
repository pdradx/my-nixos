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
	rider = prev.jetbrains.rider.overrideAttrs (old: {
	  buildInputs = (old.buildInputs or []) ++ (with pkgs; [ dotnet-sdks ]);
	  nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ pkgs.makeWrapper ];
	  #postInstall = (old.postInstall or "") + ''
	  #  mv $out/bin/rider $out/bin/.rider-wrapped
	  #  makeWrapper $out/bin/.rider-wrapped $out/bin/rider \
	  #    --prefix PATH : ${pkgs.msbuild}/bin
	  #'';

	  #    --set DOTNET_ROOT ${pkgs.dotnet-sdk_10} \

	  postInstall = (old.postInstall or "") + ''
	    mv $out/bin/rider $out/bin/.rider-wrapped
	    makeWrapper $out/bin/.rider-wrapped $out/bin/rider \
	      --set DOTNET_ROOT ${dotnet-sdks} \
	      --prefix PATH : ${dotnet-sdks}/bin \
	      --prefix PATH : ${pkgs.msbuild}/bin
	  '';
	}
      );
    };
    })
  ];

  environment.systemPackages = with pkgs; [
    jetbrains.rider
  ];
}
