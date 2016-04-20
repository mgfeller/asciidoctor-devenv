Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.hostname = "adoc-devenv"
  
  # doesn't work on windows 10 with virtualbox 5.0.10, unless you manually check the "VirtualBox NDIS6 Bridged Networking Driver" 
  # in the network adapters property page after the adapter has been created. 
  # In other words: running vagrant up for the first time will create the adapter, but fail to startup the
  # virtual box. Find the created network adapter in the Windows 10 settings, select its properties, and select (check) 
  # "VirtualBox NDIS6 Bridged Networking Driver". Run vagrant up again, this time the box should start normally.
  config.vm.network "private_network", ip: "192.168.33.10"
  # using this as a workaround instead
  # config.vm.network "public_network"
  # or this (adjust IP as needed)
  # config.vm.network "public_network", ip: "192.168.1.166"

  config.vm.synced_folder "src/", "/work/src"
  
  # Installation of "VirtualBox Guest Additions" (https://github.com/dotless-de/vagrant-vbguest):
  # Install vbguest plugin with: 
  # vagrant plugin install vagrant-vbguest
  # Uncomment the following (change version if necessary)
  # config.vbguest.auto_update = true
  # config.vbguest.iso_path = 'http://download.virtualbox.org/virtualbox/5.0.18/VBoxGuestAdditions_5.0.18.iso'

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file  = "vagrant.pp"
  end

end
