{ ... }: {
  programs.ssh = {
    enable = true;

    enableDefaultConfig = false;

    extraOptionOverrides = {
      HostKeyAlgorithms = "+ssh-rsa";
      PubkeyAcceptedKeyTypes = "+ssh-rsa";
    };

    settings."*" = {
      ForwardAgent = "yes";
      HashKnownHosts = "no";
      UserKnownHostsFile = "~/.ssh/known_hosts";
    };
  };
}
