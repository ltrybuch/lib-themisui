# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "kierse/debian-wheezy"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 3042, host: 3042

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:

  config.vm.provider "virtualbox" do |vb|
    vb.name = "ThemisUI"
    vb.memory = "1024"
    vb.cpus = 2
  end

  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL

  config.vm.provision "shell", inline: "echo '#{format("APT Configuration")}'"
  config.vm.provision "shell", inline: "echo 'APT::Install-Recommends \"false\";' > /etc/apt/apt.conf.d/99recommends"
  config.vm.provision "shell", inline: "echo 'APT::Install-Suggests \"false\";' > /etc/apt/apt.conf.d/99suggests"

  config.vm.provision "shell", inline: "aptitude update"

  # Install Prereqs
  config.vm.provision "shell", inline: "echo '#{format("Install Prereqs")}'"
  # config.vm.provision "shell", inline: "DEBIAN_FRONTEND=noninteractive apt-get -y upgrade"
  config.vm.provision "shell", inline: "apt-get install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev"
  config.vm.provision "shell", inline: "apt-get install -y vim emacs nano"
  config.vm.provision "shell", inline: "apt-get install -y libxml2-dev libxslt-dev qt4-dev-tools libqt4-dev libqt4-core libqt4-gui libqtwebkit-dev"
  config.vm.provision "shell", inline: "apt-get install -y git"
  config.vm.provision "shell", inline: "apt-get install -y ack-grep curl dstat fping ifstat iftop keychain mtr-tiny nmap pv realpath rsync screen strace tcpdump unzip zip"
  config.vm.provision "shell", inline: "apt-get install -y python-software-properties xvfb"
  # config.vm.provision "shell", inline: "apt-get install -y nodejs nodejs-legacy"

  # install NPM manually
  config.vm.provision "shell", inline: "curl -L --insecure https://www.npmjs.org/install.sh | bash"
end
