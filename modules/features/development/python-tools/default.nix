{
  hosts = [
    "attodesk"
    "attolap"
  ];
  systemPackages = pkgs: [
    (pkgs.python3.withPackages (
      pythonPackages: with pythonPackages; [
        colorama
        icmplib
        ntplib
        pip
        pytz
        requests
        urllib3
      ]
    ))
  ];
}
