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

    settings."10.2.* 10.3.* 172.16.*" = {
      strictHostKeyChecking = "no";
      userKnownHostsFile = "/dev/null";
    };
  };
}
