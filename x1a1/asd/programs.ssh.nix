{ ... }: {
  programs.ssh = {
    enable = true;

    enableDefaultConfig = false;

    extraOptionOverrides = {
      HostKeyAlgorithms = "+ssh-rsa";
      PubkeyAcceptedKeyTypes = "+ssh-rsa";
    };

    matchBlocks."*" = {
      addKeysToAgent = "yes";
      forwardAgent = true;
      hashKnownHosts = false;
      userKnownHostsFile = "~/.ssh/known_hosts";
    };
  };
}
