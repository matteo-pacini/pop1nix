{
  stdenvNoCC,
  lib,
  makeWrapper,
  dosbox-x,
}:
let
  popSources = ../../data/pop1;
  popResources = ../../resources/pop1;
  popDosbox = dosbox-x.overrideAttrs (
    finalAttrs: oldAttrs: {
      patches = (oldAttrs.patches or [ ]) ++ [ ./001-add-cfbundledisplayname.patch ];
      postPatch =
        oldAttrs.postPatch
        + ''
          substituteInPlace src/gui/sdlmain.cpp \
            --replace-fail "SDL_SetWindowTitle(sdl.window,title);" \
                           "SDL_SetWindowTitle(sdl.window,\"Prince Of Persia\");"
        '';

      postInstall =
        oldAttrs.postInstall
        + lib.optionalString stdenvNoCC.isDarwin ''
          cp -r ${popResources}/dosbox-x.icns \
                $out/Applications/dosbox-x.app/Contents/Resources/

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
  src = popSources;

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,/share/pop1}
    cp -r $src/** $out/share/pop1/
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
