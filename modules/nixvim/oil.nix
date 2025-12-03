{
  programs.nixvim.keymaps = [
    {
      action = "<cmd>Oil<CR>";
      key = "-";
      mode = ["n"];
    }
  ];

  programs.nixvim.plugins.oil = {
    enable = true;

    settings = {
      columns = ["icon"];
      view_options.show_hidden = true;
      keymaps = {
        "<C-p>" = false;
      };
      skip_confirm_for_simple_edits = true;
    };
  };
}
