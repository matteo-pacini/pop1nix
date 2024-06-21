# POP1Nix

Welcome to the ultimate way to play Prince of Persia 1 on UNIX systems using Nix flakes! 

This project uses DOSBOX-X, a DOS emulator, with some cool patches to give you a smooth gaming experience.
🌟

## How to Play

You can dive right into the action with this command:

```bash
nix run "github:matteo-pacini/pop1nix#pop1"
```

This command sets up everything, mounts the game directory, and launches Prince of Persia 1 using the patched DOSBOX-X.

Don't Have Flakes and nix-command Enabled? No Worries!

If you haven't enabled flakes and nix-command, you can still join the fun. Just use this command:


```bash
nix --extra-experimental-features 'nix-command flakes' run "github:matteo-pacini/pop1nix#pop1"
```

## Technical Magic 🪄

- Wrapper Script: This nifty script initializes DOSBOX-X, mounts the game directory, and starts the game for you.
- External Patch: Changes the macOS app title to "PrinceOfPersia".
- Inline patch: Hardcodes the window title to "PrinceOfPersia" for a uniform look on all platforms.

## macOS Goodies 🍏

- Custom titlebar title in the .app Info.plist.
- A custom icon to replace the default DOSBOX-X icon.

## Note

This project is just for fun and to show off what Nix flakes can do with classic games on modern UNIX systems. All trademarks and copyrights are owned by their respective owners.