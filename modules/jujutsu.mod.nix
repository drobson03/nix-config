{
  flake.homeModules.jujutsu = {
    programs.jujutsu.enable = true;
    programs.jujutsu.settings = {
      aliases.".." = ["edit" "@-"];
      aliases.",," = ["edit" "@+"];

      aliases.log-ancestors = ["log" "--revisions" "::"];
      aliases.log-summary = ["log" "--summary"];
      aliases.log-summary-ancestors = ["log" "--summary" "--revisions" "::"];
      aliases.log-patch = ["log" "--patch"];
      aliases.log-patch-ancestors = ["log" "--patch" "--revisions" "::"];

      aliases.tug = ["bookmark" "advance" "--to" "closest_pushable(@-)"];
      aliases.bc = ["bookmark" "create" "-r" "@-"];

      revset-aliases."closest(to)" = "heads(::to & bookmarks())";
      revset-aliases."closest_pushable(to)" = "heads(::to & ~description(exact:\"\") & (~empty() | merges()))";

      revsets.log = "present(@) | present(trunk()) | ancestors(remote_bookmarks().. | @.., 8)";

      ui.default-command = "log-summary";

      ui.diff-editor = ":builtin";
      ui.diff-formatter = ["difft" "--color" "always" "$left" "$right"];

      ui.conflict-marker-style = "snapshot";
      ui.graph.style = "square";

      templates.draft_commit_description =
        /*
        python
        */
        ''
          concat(
            coalesce(description, "\n"),
            surround(
              "\nJJ: This commit contains the following changes:\n", "",
              indent("JJ:     ", diff.stat(72)),
            ),
            "\nJJ: ignore-rest\n",
            diff.git(),
          )
        '';

      remotes.origin.auto-track-bookmarks = "glob:*";

      git.fetch = ["origin" "upstream"];
      git.push = "origin";

      signing.backend = "ssh";
      # Sign on push rather than on every rewrite, so a YubiKey-backed key
      # doesn't need a touch for each jj command.
      signing.behavior = "drop";
      git.sign-on-push = true;
    };
  };
}
