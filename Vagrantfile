Vagrant.configure(2) do |config|
  # Base the project on Ubuntu (Trusty):
  config.vm.box = "ubuntu/trusty64"

  config.vm.hostname = "adoc-devenv"
 
  config.vm.network "private_network", ip: "192.168.33.10"
  
  # Setting up the private  network doesn't work on windows 10 with Virtualbox 5.0.10, unless you manually 
  # check the "VirtualBox NDIS6 Bridged Networking Driver" in the network adapters property page after the adapter has been created. 
  # In other words: running vagrant up for the first time will create the adapter, but fail to startup the
  # virtual box. Find the created network adapter in the Windows 10 settings, select its properties, and select (check) 
  # "VirtualBox NDIS6 Bridged Networking Driver". Run vagrant up again, this time the box should start normally.
  # As a workaround, a public network can be configured instead, using
  # config.vm.network "public_network"
  # or with a specific IP address:
  # config.vm.network "public_network", ip: "192.168.1.166"

  # Map the local folder containing possible sources to the folder /work/src in the box. 
  config.vm.synced_folder "src/", "/work/src"
  
  # Installation of "VirtualBox Guest Additions" (https://github.com/dotless-de/vagrant-vbguest):
  # Make sure to install/upgrade vbguest plugin with: 
  # vagrant plugin install vagrant-vbguest
  # (Re)installing this plugin fixed the EACCES error on Windows 10 described in 
  # https://github.com/dotless-de/vagrant-vbguest/issues/189
  #
  # Uncomment the following (change version if necessary)
  # config.vbguest.auto_update = true
  # config.vbguest.iso_path = 'http://download.virtualbox.org/virtualbox/5.1.2/VBoxGuestAdditions_5.1.2.iso'

  # Configure provisioning with Puppet:
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file  = "vagrant.pp"
  end

end
