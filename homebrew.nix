{ inputs, pkgs, ... }: {
  homebrew = {
    enable = true;

    #Automatically install/update/uninstall
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
    global = {
      brewfile = true;
      autoUpdate = true;
    };

    taps = [
      "homebrew/core"
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/services"
    ];

    brews = [
	"pipx"
	"uv"
    ];

    #GUI Applications
    casks = [
      "podman-desktop"
      {
        name = "firefox";
        greedy = true;
      }
      {
	name = "discord";
	greedy = true;
      }
      {
	name = "nordvpn";
	greedy = true;
      }
      {
	name = "obsidian";
	greedy = true;
      }
      {
	name = "claude";
	greedy = true;
      }
      {
	name = "wezterm";
	greedy = true;
      }
      { 
	name = "nordpass";
	greedy = true;
      }
      { 
	name = "adguard";
	greedy = true;
      }

    ];

    # Mac App store apps (optional)
    masApps = {
      # "App Name" = app-id;
      "Kindle" = 302584613;
      "Vimlike" = 1584519802;
    };
  };
}
