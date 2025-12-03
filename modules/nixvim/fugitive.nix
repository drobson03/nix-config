{
  programs.nixvim.plugins.fugitive.enable = true;

  programs.nixvim.keymaps = [
    {
      action = "<cmd>vert Git<CR>";
      key = "<leader>gs";
      mode = ["n"];
    }
  ];
}
