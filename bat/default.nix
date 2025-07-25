{ pkgs, ... }: {
  programs.bat = {
    enable = true;
    config = {
      # Show line numbers, git modifications and file header (but no grid)
      style = "numbers,changes,header";
      theme = "gruvbox-dark";
    };
    extraPackages = builtins.attrValues {
      inherit (pkgs.bat-extras)

        batgrep #search through and highlight files using ripgrep
        batdiff #Diff a file against the current git index, or display the diff between two files
        batman; #Read manpages using bat as the formatter
    };
  };
}
