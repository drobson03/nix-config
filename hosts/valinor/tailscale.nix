{
  # Log in once with `sudo tailscale up`; state persists in /var/lib/tailscale.
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };
}
