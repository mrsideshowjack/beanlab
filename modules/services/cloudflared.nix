{ config, pkgs, ... }:

{
  services.cloudflared = {
    enable = true;
    package = pkgs.cloudflared;
    user = "bean";
    group = "users";
    tunnels = {
      "851dd3ff-a13f-4db7-a23a-7c366b9567e4" = {
        credentialsFile = "/home/bean/.cloudflared/851dd3ff-a13f-4db7-a23a-7c366b9567e4.json";
        default = "http_status:404";
        ingress = {
          "beanlab.jack-mason.dev" = "http://localhost:3000";
        };
      };
    };
  };
}