Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.hostname = "awestruct"

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file  = "vagrant.pp"
  end

end
