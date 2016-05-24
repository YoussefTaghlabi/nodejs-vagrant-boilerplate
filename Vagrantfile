#
# NodeJS & Vagrant boilerplate
#
# Ubuntu 14.04 Trusty
# Nodejs 6.2.0
# Npm    3.8.2

Vagrant.configure('2') do |config|

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/trusty64"

  # Box Url
  config.vm.box_url = 'https://atlas.hashicorp.com/ubuntu/boxes/trusty64/versions/20160318.0.0/providers/virtualbox.box'

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network :private_network, ip: '10.0.0.3'

  # Change hostname
  config.vm.hostname = "nodejs"

  config.vm.synced_folder "./", "/vagrant", id: "vagrant-root",
    owner: "vagrant",
    group: "www-data",
    mount_options: ["dmode=775,fmode=774"]

  # Forward SSH Agent
  config.ssh.forward_agent = true

  # Repair "==> default: stdin: is not a tty" message
  config.ssh.shell = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--memory", 2048]
    v.customize ["modifyvm", :id, "--name", "nodejs_vagrant_vm_v1"]
  end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision :shell, :path => "provision/setup.sh", privileged: false

end
