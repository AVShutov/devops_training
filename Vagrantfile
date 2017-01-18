# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|
 
#########################################################
if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.http     = "http://10.4.252.10:3128/"
    config.proxy.https    = "https://10.4.252.10:3128/"
    config.proxy.no_proxy = "localhost,127.0.0.1,10.*.*.*,.rw"
  end
#########################################################
  
  config.vm.box = "bertvv/centos72"
  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
  end
  config.vm.define "server1" do |server1|
	server1.vm.hostname = "server1"
	server1.vm.network "private_network", ip: "172.20.20.10", auto_config: false 
    	server1.vm.provision "yum", type: "shell", inline: <<-SHELL
        sudo yum install git -y
	git clone https://github.com/AVShutov/devops_training.git
	cd devops_training	
	git checkout task1
	SHELL
  end
  config.vm.define "server2" do |server2|
	server2.vm.hostname = "server2"
	server2.vm.network "private_network", ip: "172.20.20.11", auto_config: false
  end
end
