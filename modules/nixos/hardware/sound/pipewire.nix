{
  # Let PipeWire/WirePlumber request real-time scheduling via RTKit.
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;

    # extraConfig.pipewire."10-low-latency" = {
    #   "context.properties" = {
    #     # Keep the PipeWire graph at a 1024-frame quantum for stability under load.
    #     "default.clock.min-quantum" = 512;
    #     "default.clock.max-quantum" = 1024;
    #     "default.clock.quantum" = 512;
    #     "default.clock.quantum-limit" = 1024;
    #   };
    # };

    wireplumber.extraConfig."20-scarlett-solo" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            {
              "device.name" = "alsa_card.usb-Focusrite_Scarlett_Solo_4th_Gen_S1M5P213B255F6-00";
            }
          ];
          actions = {
            "update-props" = {
              # Use a more conservative USB profile for the Scarlett card as a whole.
              "api.alsa.disable-batch" = true;
              "api.alsa.disable-mmap" = true;
              "api.alsa.period-num" = 8;
              "api.alsa.period-size" = 256;
              "api.alsa.headroom" = 128;
            };
          };
        }
      ];
    };

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
