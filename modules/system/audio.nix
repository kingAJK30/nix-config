{ ... }:

{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.pipewire.wireplumber.extraConfig = {
    "default-sink" = {
      "wireplumber.settings" = {
        "default.configured-audio-sink" = "alsa_output.usb-Kingston_Technology_Company_HyperX_Cloud_Flight_Wireless-00.analog-stereo";
      };
    };
  };
}
