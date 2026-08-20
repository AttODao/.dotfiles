{
  services.pipewire = {
    wireplumber.extraConfig."20-scarlett-solo" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            {
              "device.name" = "alsa_card.usb-Focusrite_Scarlett_Solo_4th_Gen_S1M5P213B255F6-00";
            }
          ];
          actions."update-props" = {
            # Disabling mmap and batching avoids underruns on this Scarlett USB device.
            "api.alsa.disable-batch" = true;
            "api.alsa.disable-mmap" = true;
            "api.alsa.period-num" = 8;
            "api.alsa.period-size" = 256;
            "api.alsa.headroom" = 128;
          };
        }
      ];
    };

    # Expose the capture-card input as a virtual source instead of playing it on
    # whichever physical sink WirePlumber currently selects.
    extraConfig.pipewire."99-kuro-loopback"."context.modules" = [
      {
        name = "libpipewire-module-loopback";
        args = {
          "node.description" = "KURO Loopback";
          "capture.props" = {
            "target.object" = "alsa_input.usb-KURO-CPC_KURO-CPC-4K1C1PTwA_33400041-02.analog-stereo";
            "node.passive" = true;
            "node.dont-reconnect" = true;
          };
          "playback.props" = {
            "node.name" = "kuro_capture";
            "media.class" = "Audio/Source";
            "audio.position" = [
              "FL"
              "FR"
            ];
          };
        };
      }
    ];
  };
}
