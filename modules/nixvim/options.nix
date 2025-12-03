{
  programs.nixvim.globals.mapleader = " ";

  programs.nixvim.opts = {
    nu = true;
    rnu = true;
    mouse = "a";
    showmode = false;
    tabstop = 2;
    softtabstop = 2;
    shiftwidth = 2;
    expandtab = true;
    smartindent = true;
    breakindent = true;
    wrap = false;
    swapfile = false;
    backup = false;
    undofile = false;
    hlsearch = false;
    incsearch = true;
    ignorecase = true;
    smartcase = true;
    inccommand = "split";
    termguicolors = true;
    scrolloff = 8;
    signcolumn = "yes";
    updatetime = 0;
    colorcolumn = "80";
    list = true;
    listchars = {
      tab = "» ";
      trail = "·";
      nbsp = "␣";
    };
    cursorline = true;
    splitright = true;
    splitbelow = true;
    autoread = true;
  };
}
