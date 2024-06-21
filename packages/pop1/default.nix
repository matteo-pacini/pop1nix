{
  stdenvNoCC,
  lib,
  makeWrapper,
  dosbox-x,
}:
let
  # Game sources
  popSources = ../../data/pop1;
  # Game extra resources (i.e. macOS icon)
  popResources = ../../resources/pop1;
  # Custom DOSBox-X derivation
  popDosbox = dosbox-x.overrideAttrs (
    finalAttrs: oldAttrs: {
      postPatch =
        oldAttrs.postPatch
        + ''
          # This is a hack to set the window title to "Prince Of Persia"
          substituteInPlace src/gui/sdlmain.cpp \
            --replace-fail "SDL_SetWindowTitle(sdl.window,title);" \
                           "SDL_SetWindowTitle(sdl.window,\"Prince Of Persia\");"
        '';

      postInstall =
        oldAttrs.postInstall
        + lib.optionalString stdenvNoCC.isDarwin ''
          # Copy the custom icon to the DOSBox-X app bundle

          cp -r ${popResources}/dosbox-x.icns \
                $out/Applications/dosbox-x.app/Contents/Resources/

          # Rename the DOSBox-X app bundle to "Prince of Persia", so it looks 
          # good on the macOS dock

          mv $out/Applications/dosbox-x.app $out/Applications/Prince\ of\ Persia.app
          unlink $out/bin/dosbox-x
          ln -s $out/Applications/Prince\ of\ Persia.app/Contents/MacOS/dosbox-x $out/bin/dosbox-x
        '';
    }
  );
in
stdenvNoCC.mkDerivation {
  pname = "prince-of-persia";
  version = "1.4-en";
  # Passing here a path to the game sources
  src = popSources;

  # We don't need to patch, configure or build anything
  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  # We need to wrap the DOSBox-X binary to launch the game
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    # Create /bin and /share/pop1 directories    
    mkdir -p $out/{bin,/share/pop1}

    # Copy the game sources to /share/pop1
    cp -r $src/** $out/share/pop1/

    # Create a wrapper around DOSBox-X to launch the game
    makeWrapper ${popDosbox}/bin/dosbox-x $out/bin/pop1 \
      --add-flags "-fastlaunch" \
      --add-flags "-c \"MOUNT C $out/share/pop1\"" \
      --add-flags "-c \"C:\"" \
      --add-flags "-c \"PRINCE.EXE\""

    runHook postInstall
  '';

  meta = {
    description = "Prince of Persia (1989) DOS Version";
    platforms = dosbox-x.meta.platforms;
  };
}
