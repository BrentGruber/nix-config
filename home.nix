{ config, pkgs, ... }:

{
	# Home Manager needs a bit of information about you and the paths it should manage
	home.username = "brent";
	

	# This value determines the Home Manager release that your configuration is compatible with
	# Helps avoid breakage when new manager release is backwards incompatible
	home.stateVersion = "23.11";

	# The home.packages option allows you to install Nix packages into your environment
	home.packages = with pkgs; [
		#Development
		nodejs_20
		python3
		go
		rustc
		cargo
		zig
		nim
		crystal
		gleam
		elixir
		terraform
		claude-code
		pkgs.karabiner-elements

		#LSP servers
		lua-language-server #lua
		pyright #python
		gopls #go
		zls # zig
		bash-language-server #bash
		alejandra #nix
		marksman #markdown
		yaml-language-server #yaml
		vscode-langservers-extracted #json, html, css, eslint
		nodePackages.eslint_d

		# CLI utilites
		htop
		tree
		curl
		wget
		ripgrep
		du-dust
		fzy
		duf
		fswatch
		fd
		kubectl
		podman
		podman-compose
		podman-tui
		skopeo

		# Compression
		atool
		unzip
		gzip
		xz
		zip

		# file viewers
		less
		page # like less, but uses nvim
		file
		jq
		yq
		lynx
		sourceHighlight
		glow
		mdcat
		html2text

		# networking
		gping
		bandwhich #bandwidth monitor by process
		static-web-server # serve local static files
		aria # cli downloader
		hostname
		trippy # mtr alternative
		xh # rust version of httpie / better curl

		# miscellaneous
		neofetch # display key software/version info in terminal
		aspell # spell checker
		kalker # cli calculator;
		rink # unit conversions
		nix-tree # dependency viewer
		asciinema # terminal screeencast
		catimg # ascii rendering of any image in terminal
		kondo # free disk space by cleaning project build dirs
		aichat


		# You can also create simple shell scripts directly inside config
		# example: add command my-hello to environment
		(pkgs.writeShellScriptBin "my-hello" ''
			echo "Hello, ${config.home.username}!"
		'')
	];

	# Home manager is pretty good at managing dotfiles. The primary way to manage
	# plain files is through home.file
	home.file = {
		# Building this configuration will createa  copy of dotfiles/creenrc in the Nix store
		# Activating the configuration will then make '~/.screenrc' a symlink to the Nix store
		# copy
		#".screenrc".source = dotfiles/screenrc;

		# neovim config
		".config/nvim/init.lua".source = dotfiles/init.lua; 

		# You can also set the file content immediately.
		".gradle/gradle.properties".text = ''
		org.gradle.console=verbose
		org.gradle.daemon.idletimeout=3600000
		'';

		# kubectl config
		".kube/config".source = dotfiles/kube-config;

	};

	home.activation.weztermConfig = config.lib.dag.entryAfter ["writeBoundary"] ''
		WEZTERM_DIR="$HOME/.config/wezterm"

		if [ -d "$WEZTERM_DIR" ]; then
			echo "Updating WezTerm config..."
			cd "$WEZTERM_DIR"
			${pkgs.git}/bin/git pull origin main
		else
			echo "Cloning WezTerm config..."
			${pkgs.git}/bin/git clone https://github.com/BrentGruber/wezterm-config.git "$WEZTERM_DIR"
		fi
	'';


	# Home manager can also manage your environment variables through 'home.sessionVariables'
	# If you don't want to manage your shell through Home Manager then you have to manually source
	# 'hm-session-vars.sh' located at ~/.nix-profile/etc/profile.d/hm-session-vars.sh
	home.sessionVariables = {
		FOO="bar";
		LANG = "en_US.UTF-8";
		LC_ALL = "en_US.UTF-8";
		KEYTIMEOUT = 1;
		GIT_EDITOR = "nvim";
		VISUAL = "nvim";
		LS_COLORS = "no=00:fi=00:di=01;34:ln=35;40:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=01;32:*.cmd=01;32:*.exe=01;32:*.com=01;32:*.btm=01;32:*.bat=01;32:";
		LSCOLORS = "ExfxcxdxCxegedabagacad";
		FIGNORE = "*.o:~:Application Scripts:CVS:.git";
		LESS = "--raw-control-chars -FXRadeqs -P--Less--?e?x(Next file: %x):(END).:?pB%pB%.";
		CLICOLOR = 1;
		CLICOLOR_FORCE = "yes";
		PAGER = "page -WO -q 90000";
		MANPAGER = "less -R --use-color -Dd+r -Du+b +Gg -M -s";
		SYSTEMD_COLORS = "true";
		COLORTERM = "truecolor";
		FZF_CtRL_R_OPTS = "--sort --exact";
	};

	# Let Home Manager install and manage itself.
	programs.home-manager.enable = true;

	# Git configuration
	programs.git = {
		enable = true;
		userName = "BrentGruber";
		userEmail = "brent.gruber77@gmail.com";
		extraConfig = {
			init.defaultBranch = "main";
			push.autoSetupRemote = true;
		};
	};

	programs.zsh = {
		enable = true;
		enableCompletion = true;
		autosuggestion.enable = true;
		syntaxHighlighting.enable = true;

		shellAliases = {
			ll = "ls -la";
			la = "ls -la";
			l  = "ls -l";
			".." = "cd ..";
			"..." = "cd ../..";
			grep = "grep --color=auto";
			cat = "bat --paging=never";
			apply-kustomize = "kubectl kustomize --enable-helm . | kubectl apply -f -";
			delete-kustomize = "kubectl kustomize --enable-helm . | kubectl delete -f -";
			docker = "podman";
			"docker-compose" = "podman-compose";
		};

		oh-my-zsh = {
			enable = true;
			plugins = ["git" "sudo" "docker" "kubectl" ];
			theme = "robbyrussell";
		};
	};

	programs.wezterm = {
		enable = true;
	};

	programs.fzf = {
		enable = true;
		enableZshIntegration = false;
		defaultCommand = "\fd --type f --hidden --exclude .git";
		fileWidgetCommand = "\fd --exclude .git --type f";
		changeDirWidgetCommand = "\fd --type d --hidden --follow --max-depth 3 --exclude .git";
	};

	programs.gh = {
		enable = true;
		package = pkgs.gh;
		settings = {git_protocol = "ssh";};
	};

	programs.starship = {
		enable = true;
		enableZshIntegration = true;
	};
	imports = [
		./nvim
		./eza
		./bat
		./wezterm
	];
}
