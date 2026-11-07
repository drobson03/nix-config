{
  services.pipewire.extraConfig = {
    pipewire."10-clock"."context.properties" = {
      "default.clock.rate" = 192000;
      "default.clock.allowed-rates" = [44100 48000 88200 96000 192000 384000];
    };

    client."10-resample"."stream.properties"."resample.quality" = 10;
  };

  services.pipewire.wireplumber.extraConfig = {
    "51-alsa-disable"."monitor.alsa.rules" = [
      {
        matches = [
          {"device.name" = "alsa_card.pci-0000_07_00.1";}
          {"device.name" = "alsa_card.pci-0000_09_00.4";}
        ];
        actions.update-props."device.disabled" = true;
      }
    ];

    "52-profiles"."monitor.alsa.rules" = [
      {
        matches = [
          {"device.name" = "alsa_card.usb-iFi_GO_link_Max_iFi_USB_Audio_SE-00";}
        ];
        actions.update-props = {
          "device.profile.pro" = "true";
          "device.profile" = "pro-audio";
          "audio.format" = "pcm_s24le";
        };
      }
    ];

    "53-audio-format"."monitor.alsa.rules" = [
      {
        matches = [
          {"node.name" = "alsa_output.usb-iFi_GO_link_Max_iFi_USB_Audio_SE-00.pro-output-0";}
        ];
        actions.update-props."audio.format" = "pcm_f32le";
      }
    ];

    "54-nt-usb-mono"."monitor.alsa.rules" = [
      {
        matches = [
          {"device.name" = "alsa_card.usb-R__DE_R__DE_NT-USB__4078C0C4-00";}
        ];
        actions.update-props = {
          "device.profile.pro" = "false";
          "device.profile" = "input:mono-fallback";
        };
      }
    ];
  };

  home-manager.users.drobson03.services.easyeffects = {
    enable = true;
    preset = "Normal";
    extraPresets = {
      Normal = builtins.fromJSON (builtins.readFile ./easyeffects/Normal.json);
      Osu = builtins.fromJSON (builtins.readFile ./easyeffects/Osu.json);
    };
  };
}
