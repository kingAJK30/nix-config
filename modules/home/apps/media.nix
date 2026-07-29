{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    mpv
    ffmpeg
    yt-dlp
    audacity
  ];
}
