{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    withPython3 = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = [];
 };
}
