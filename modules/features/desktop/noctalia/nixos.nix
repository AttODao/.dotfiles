{ hostName, lib, ... }:
lib.mkIf (hostName == "attodesk") {
  programs.gpu-screen-recorder.enable = true;
}
