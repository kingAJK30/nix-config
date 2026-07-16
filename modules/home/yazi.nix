{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ueberzugpp
  ];

  programs.yazi = {
    enable = true;
    settings = {
      manager = {
        show_hidden = true;
        sort_by = "mtime";
        sort_dir_first = true;
        sort_reverse = false;
      };
    };

    keymap = {
      manager.prepend_keymap = [
        {
          on = [ "W" ];
          run = "shell 'echo \"Binding Works!\"' --block";
          desc = "Test Binding";
        }
      ];
    };
  };
}
