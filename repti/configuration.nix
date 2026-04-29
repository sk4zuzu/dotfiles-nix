{ config, pkgs, lib, ... }: {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    bc
    dmidecode dos2unix
    edid-decode
    file
    gnupg
    jq
    libhugetlbfs
    mkpasswd
    numactl
    pciutils procs pv
    syslinux
    usbutils
  ] ++ [
    cdrkit cryptsetup
    efibootmgr exfat
    gptfdisk
    multipath-tools
    ntfs3g
    sdparm
  ] ++ [
    bridge-utils
    dnsutils
    ethtool
    iptables
    nftables nmap ntp
    openssl openvpn
    rsync
    tcpdump
    wireguard-tools
  ] ++ [
    dpdk
    openvswitch-dpdk
  ] ++ [
    bat
    fd
    git gnumake
    mc
    neovim
    patch
    ripgrep
    tmux
    vim
  ] ++ [
    acpitool
    brightnessctl btop
    cpufrequtils
    htop
    iftop iotop
    lm_sensors lsof
    nvtopPackages.amd
    perf
    wavemon
  ] ++ [
    cabextract
    p7zip
    unrar unshield unzip
    zip
  ] ++ [
    feh
    gnuplot
    mesa-demos
    xclip
    xdpyinfo xev xgamma xhost xkill xmodmap
  ];

  environment.variables = {
    EDITOR = "nvim";
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      charis
      noto-fonts
      noto-fonts-color-emoji
    ];
  };

  imports = [
    /etc/nixos/hardware-configuration.nix
    /etc/nixos/repti/hidden.nix
  ];

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/EFI";
      };
      grub = {
        enable = true;
        enableCryptodisk = true;
        device = "nodev";
        efiSupport = true;
      };
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "default_hugepagesz=1G"
      "hugepagesz=1G"
      "hugepages=16"
      "hugepagesz=2M"
      "hugepages=4096"
    ];
    kernelModules = [ "ip6table_filter" "nbd" "vhost_net" ]; #++ [ "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];
    blacklistedKernelModules = [];
    kernel.sysctl = {
      "vm.max_map_count" = 262144;
      "net.ipv6.conf.wlp6s0.disable_ipv6" = true;
    };
    extraModprobeConfig = ''
      options kvm-amd nested=1
    '';
    initrd = {
      luks.devices = {
        luks1 = { device = "/dev/disk/by-uuid/a23b3a97-9b0e-4054-9a2c-1ceeb893c74b"; keyFile = "luks"; allowDiscards = true; preLVM = true; };
      };
      secrets = {
        "luks" = /etc/secrets/initrd/luks;
      };
    };
  };

  fileSystems = {
    "/"     = { options = [ "defaults" "discard" "noatime" "nodiratime" "nobarrier" ]; };
    "/home" = { options = [ "defaults" "discard" "noatime" "nodiratime" "nobarrier" ]; };
    "/stor" = { options = [ "defaults" "discard" "noatime" "nodiratime" ]; };
  };

  powerManagement.cpuFreqGovernor = "conservative";

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  networking = {
    useNetworkd = true;
    useDHCP = false;
    enableIPv6 = true;
    hostName = "repti";
    extraHosts = ''
      127.0.0.1 lh
      10.2.31.10 c2.alma.lh
      10.2.31.86 c2-ha.alma.lh
      10.2.81.10 d1.debian.lh
      10.2.81.86 d1-ha.debian.lh
      10.2.70.10 r1.redhat.lh
      10.2.70.86 r1-ha.redhat.lh
      10.2.60.10 s1.opensuse.lh
      10.2.60.86 s1-ha.opensuse.lh
      10.2.61.10 s2.suse.lh
      10.2.61.86 s2-ha.suse.lh
      10.2.80.10 u1.ubuntu.lh
      10.2.80.86 u1-ha.ubuntu.lh
    '';
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    wireless = {
      enable = true;
      userControlled = true;
      interfaces = [ "wlp6s0" ];
      extraConfigFiles = [ "/etc/wpa_supplicant.conf" ];
    };
    nat = {
      enable = true;
      externalInterface = "wlp6s0";
    };
    firewall = {
      enable = true;
      checkReversePath = false;
      trustedInterfaces = [ "br0" ];
      allowedTCPPorts = [ 80 4430 5000 6112 8000 ] ++ [ 111 2049 4000 4001 4002 20048 ] ++ [ 5005 6443 ] ++ [ 389 514 ];
      allowedUDPPorts = [ 5029 5353 6112 27960 ] ++ [ 111 2049 4000 4001 4002 20048 ];
    };
  };

  systemd.network = {
    networks."wlp6s0" = {
      matchConfig.Name = "wlp6s0";
      networkConfig.DHCP = "yes";
    };
    netdevs."br0" = {
      netdevConfig = {
        Kind = "bridge";
        Name = "br0";
      };
    };
    networks."br0" = {
      matchConfig.Name = "br0";
      networkConfig = {
        Address = "10.2.11.1/24";
        IPv4Forwarding = "yes";
        IPv6Forwarding = "yes";
        IPMasquerade = "no";
        ConfigureWithoutCarrier = "yes";
      };
      linkConfig = { ActivationPolicy = "always-up"; };
    };
  };

  systemd.services = {
    "systemd-networkd-wait-online".serviceConfig.ExecStart = [
      "" "${config.systemd.package}/lib/systemd/systemd-networkd-wait-online --any"
    ];
  };

  i18n.defaultLocale = "en_US.UTF-8";

  console.keyMap = "pl";

  time = {
    timeZone = "Europe/Warsaw";
    hardwareClockInLocalTime = false;
  };

  security = {
    doas = {
      enable = true;
      extraRules = [ { groups = [ "wheel" ]; noPass = true; keepEnv = false; setEnv = [ "LOCALE_ARCHIVE" ]; } ];
    };
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  programs = {
    dconf.enable = true;
    slock.enable = true;
  };

  virtualisation = {
    docker = {
      enable = true;
      daemon.settings = {
        log-driver = "local";
        features = { containerd-snapshotter = true; };
        ip6tables = false;
      };
    };
    #podman = {
    #  enable = true;
    #  dockerCompat = true;
    #};
    libvirtd = {
      enable = true;
      qemu.vhostUserPackages = [ pkgs.virtiofsd ];
      allowedBridges = [ "all" ];
    };
    vswitch = {
      enable = true;
      package = pkgs.openvswitch-dpdk;
    };
  };

  services = {
    chrony.enable = true;
    displayManager = {
      enable = true;
      autoLogin = {
        enable = true;
        user = "sk4zuzu";
      };
      defaultSession = "none+xmonad";
    };
    fwupd.enable = true;
    libinput = {
      enable = true;
      touchpad.tapping = true;
    };
    nfs.server = {
      enable = true;
      lockdPort = 4001;
      mountdPort = 4002;
      statdPort = 4000;
      extraNfsdConfig = '''';
      exports = ''
        /stor/export 10.2.0.0/16(rw,fsid=0,no_subtree_check,no_root_squash)
      '';
    };
    ntp.enable = false;
    openldap = {
      enable = true;
      urlList = [ "ldap:///" ];
      settings = {
        attrs = { olcLogLevel = "conns config"; };
        children = {
          "cn=schema".includes = [
            "${pkgs.openldap}/etc/schema/core.ldif"
            "${pkgs.openldap}/etc/schema/cosine.ldif"
            "${pkgs.openldap}/etc/schema/inetorgperson.ldif"
            "${pkgs.openldap}/etc/schema/nis.ldif"
          ];
          "cn=module{0}".attrs = {
            objectClass = [ "olcModuleList" ];
            olcModuleLoad = [ "memberof" "refint" ];
          };
          "olcDatabase={1}mdb".attrs = {
            objectClass = [ "olcDatabaseConfig" "olcMdbConfig" ];
            olcDatabase = "{1}mdb";
            olcDbDirectory = "/var/lib/openldap/data";
            olcSuffix = "dc=sk4zuzu,dc=eu";
            olcRootDN = "cn=admin,dc=sk4zuzu,dc=eu";
            olcRootPW = "asd123";
          };
          "olcDatabase={1}mdb".children = {
            "olcOverlay={0}memberof".attrs = {
              objectClass = [ "olcOverlayConfig" "olcMemberOf" ];
              olcOverlay = "{0}memberof";
              olcMemberOfDangling = "ignore";
              olcMemberOfRefInt = "TRUE";
              olcMemberOfGroupOC = "groupOfNames";
              olcMemberOfMemberAD = "member";
              olcMemberOfMemberOfAD = "memberOf";
            };
            "olcOverlay={1}refint".attrs = {
              objectClass = [ "olcOverlayConfig" "olcRefintConfig" ];
              olcOverlay = "{1}refint";
              olcRefintAttribute = [ "memberof" "member" "manager" "owner" ];
            };
          };
        };
      };
      declarativeContents."dc=sk4zuzu,dc=eu" = ''
        dn: dc=sk4zuzu,dc=eu
        objectClass: domain
        dc: sk4zuzu

        dn: ou=users,dc=sk4zuzu,dc=eu
        objectClass: organizationalUnit
        ou: users

        dn: cn=asd,ou=users,dc=sk4zuzu,dc=eu
        objectClass: inetOrgPerson
        objectClass: person
        userPassword: asd123
        uid: asd
        sn: asd.asd
        cn: asd

        dn: ou=groups,dc=sk4zuzu,dc=eu
        objectClass: organizationalUnit
        ou: groups

        dn: cn=users,ou=groups,dc=sk4zuzu,dc=eu
        objectClass: groupOfNames
        member: cn=asd,ou=users,dc=sk4zuzu,dc=eu
        cn: users
      ''; # keep empty lines!
    };
    openssh = {
      enable = true;
      ports = [ 2222 ];
    };
    picom = {
      enable = true;
      backend = "glx";
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
    };
    resolved = {
      enable = true;
      settings.Resolve.DNSSEC = "false";
      settings.Resolve.LLMNR = "false";
      settings.Resolve.MulticastDNS = "false";
    };
    rsyslogd = {
      enable = true;
      extraConfig = ''
        module(load="imtcp")
        input(type="imtcp" port="514")
        template(name="RemoteHostLogs" type="string" string="/var/log/remote/%HOSTNAME%/syslog.log")
        if ($fromhost-ip != '127.0.0.1') then {
            action(type="omfile" dynaFile="RemoteHostLogs")
            stop
        }
      '';
    };
    xserver = {
      enable = true;
      autorun = true;
      xkb.layout = "pl";
      desktopManager = {
        xterm.enable = false;
      };
      windowManager = {
        xmonad = {
          enable = true;
          enableContribAndExtras = true;
        };
      };
      videoDrivers = [ "modesetting" ];
    };
  };

  users.users = {
    asd = {
      isNormalUser = true;
      uid = 1000;
      group = "wheel";
      extraGroups = [ "audio" "video" "docker" "libvirtd" "kvm" ];
    };
    ead = {
      isNormalUser = true;
      uid = 8686;
      group = "wheel";
      extraGroups = [ "audio" "video" "docker" "libvirtd" "kvm" ];
    };
    sk4zuzu = {
      isNormalUser = true;
      uid = 6969;
      group = "wheel";
      extraGroups = [ "audio" "video" "docker" "libvirtd" "kvm" ];
    };
  };

  system.stateVersion = "26.05";
}
