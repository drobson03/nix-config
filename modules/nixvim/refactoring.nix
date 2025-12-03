{
  programs.nixvim.plugins.refactoring.enable = true;

  programs.nixvim.keymaps = [
    {
      action.__raw = ''
        function()
          require("refactoring").refactor("Inline Variable")
        end
      '';
      key = "<leader>ri";
      mode = ["n" "x"];
    }
    {
      action.__raw = ''
        function()
          require("refactoring").refactor("Inline Function")
        end
      '';
      key = "<leader>rI";
      mode = ["n"];
    }
  ];
}
