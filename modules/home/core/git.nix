{
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "KingAJK30";
    userEmail = "86845258+kingAJK30@users.noreply.github.com";
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };
}
