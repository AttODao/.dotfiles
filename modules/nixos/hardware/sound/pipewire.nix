{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;

    extraConfig.pipewire."99-kuro-loopback" = {
      "context.modules" = [
        {
          name = "libpipewire-module-loopback";
          args = {
            "node.description" = "KURO Loopback";

            "capture.props" = {
              "target.object" = "alsa_input.usb-KURO-CPC_KURO-CPC-4K1C1PTwA_33400041-02.analog-stereo";
            };

            "playback.props" = {
              "audio.position" = [
                "FL"
                "FR"
              ];
            };
          };
        }
      ];
    };
  };
}
