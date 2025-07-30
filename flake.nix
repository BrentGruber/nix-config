{
  description = "My Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    homebrew-core = {
	url = "github:homebrew/homebrew-core";
	flake = false;
    };
    homebrew-cask = {
	url = "github:homebrew/homebrew-cask";
	flake = false;
    };
   homebrew-bundle = {
	url = "github:homebrew/homebrew-bundle";
	flake = false;
    };
    homebrew-services = {
	url = "github:homebrew/homebrew-services";
	flake = false;
    };

    # Claude
    claude-code.url = "github:sadjow/claude-code-nix";

    # For installing nightly build of neovim, using this to get the built in package manager
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nix-homebrew, homebrew-core, homebrew-cask, homebrew-bundle, homebrew-services, claude-code, neovim-nightly-overlay}:
    let

      overlays = {
	nixpkgs.overlays = overlays;
      };
      configuration = { pkgs, ... }: {
        # List packages installed in system profile. To search by name
        # run: $ nix-env -qaP | grep wget
        environment.systemPackages = with pkgs; [
          vim
          git
          curl
          wget
          htop
          tree
        ];

	system.primaryUser = "brent";
	nixpkgs.config.allowUnfree = true;

	fonts.packages = with pkgs; [
		roboto-slab
		nerd-fonts.fira-code
		nerd-fonts.hasklug
		nerd-fonts.jetbrains-mono
	];

        # Auto upgrade nix package and the daemon service
        nix.package = pkgs.nix;


        nix.settings.experimental-features = "nix-command flakes";

        # Create /etc/zshrc that loads the nix-darwin environment.
        programs.zsh.enable = true;

        # Set git commit hash for darwin-version
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, $darwin-rebuild changelog
        system.stateVersion = 4;

        # The platform the configuration will be used on
        nixpkgs.hostPlatform = "aarch64-darwin";

      };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations."simple" = nix-darwin.lib.darwinSystem {


        system.pam.enableSudoTouchId = true;

        #Keyboard
        system.keyboard.enableKeyMapping = true;
        system.keyboard.remapCapsLockToEscape = true;


        system.defaults = {
          dock.autohide = true;
          dock.mru-spaces = false;
          finder.AppleShowAllExtensions = true;
          finder.FXPreferredViewStyle = "clmv";
          finder._FXShowPosixPathInTitle = true;
          loginwindow.LoginwindowText = "Managed by Nix";
          screencapture.location = "~/Screenshots";
          screensaver.askForPasswordDelay = 10;
          NSGlobalDomain.AppleShowAllExtensions = true;
          NSGlobalDomain.InitialKeyRepeat = 14;
          NSGlobalDomain.KeyRepeat = 1;
        };

        modules = [
          configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.brent = import ./home.nix;
            users.users.brent.home = "/Users/brent";
          }
	  nix-homebrew.darwinModules.nix-homebrew
	  {
	    nix-homebrew = {
	      # Install under default prefix
	      enable = true;
	  

	      # Apple Silicon only
	      enableRosetta = true;

	      # user owning the homebrew prefix
	      user = "brent";

	      # Manage taps here
	      taps = with inputs; {
		"homebrew/homebrew-core" = homebrew-core;
		"homebrew/homebrew-cask" = homebrew-cask;
		"homebrew/homebrew-bundle" = homebrew-bundle;
		"homebrew/homebrew-services" = homebrew-services;
	      };

	      # Optional: Enable fully-declarative tap management
	      #
	      # with mutableTaps disables, taps can no longer be added imperatively
	      mutableTaps = false;
	    };
 	  }
	  { nixpkgs.overlays = overlays; }
          ./homebrew.nix
	];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."simple".pkgs;
    };
}
