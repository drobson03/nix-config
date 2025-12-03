{
  programs.nixvim.plugins.cloak.enable = true;

  programs.nixvim.keymaps = [
    {
      action = "<cmd>CloakToggle<CR>";
      key = "<leader>cc";
      mode = ["n"];
    }
  ];
}
