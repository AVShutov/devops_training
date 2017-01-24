# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|
####Proxy Settings############################################
  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.http     = "http://10.4.252.10:3128/"
    config.proxy.https    = "https://10.4.252.10:3128/"
    config.proxy.no_proxy = "localhost,127.0.0.1,10.*.*.*,*.rw"
  end
##############################################################
  config.vm.box = "bertvv/centos72"
  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
  end

  config.vm.define "apache1" do |apache1|

    apache1.vm.hostname = "apache1"
    apache1.vm.network "private_network", ip: "192.168.20.10"
    apache1.vm.network "forwarded_port", guest: 80, host: 80

    apache1.vm.provision "yum", type: "shell", inline: <<-SHELL
    sudo systemctl restart network
    sudo systemctl stop firewalld.service
    sudo yum install httpd -y
    sudo cp /vagrant/mod_jk.so /etc/httpd/modules/
#############################################################
sudo cat > /etc/httpd/conf/workers.properties <<-EOF
worker.list=lb, status
worker.lb.type=lb
worker.lb.balance_workers=tomcat1, tomcat2
worker.tomcat1.host=192.168.20.11
worker.tomcat1.port=8009
worker.tomcat1.type=ajp13
worker.tomcat2.host=192.168.20.12
worker.tomcat2.port=8009
worker.tomcat2.type=ajp13
worker.status.type=status
EOF
#############################################################
sudo cat >> /etc/httpd/conf/httpd.conf <<-EOF
LoadModule jk_module modules/mod_jk.so
JkWorkersFile conf/workers.properties
JkShmFile /tmp/shm
JkLogFile logs/mod_jk.log
JkLogLevel info
JkMount /new* lb
JkMount /jk-status status
EOF
#############################################################
    sudo systemctl enable httpd
    sudo systemctl start httpd

    SHELL
  end

  config.vm.define "tomcat1" do |tomcat1|

    tomcat1.vm.hostname = "tomcat1"
    tomcat1.vm.network "private_network", ip: "192.168.20.11"
    tomcat1.vm.network "forwarded_port", guest: 8080, host: 21080

    tomcat1.vm.provision "yum", type: "shell", inline: <<-SHELL
    sudo systemctl restart network
    sudo systemctl stop firewalld.service
    sudo yum install java-1.8.0-openjdk -y
    sudo yum install tomcat tomcat-webapps tomcat-admin-webapps -y
    sudo systemctl start tomcat
    sudo systemctl enable tomcat
    sudo mkdir /usr/share/tomcat/webapps/new
    echo Hello from Tomcat 1| sudo tee -a /usr/share/tomcat/webapps/new/index.html >/dev/null	

    SHELL

  end

  config.vm.define "tomcat2" do |tomcat2|

    tomcat2.vm.hostname = "tomcat2"
    tomcat2.vm.network "private_network", ip: "192.168.20.12"
    tomcat2.vm.network "forwarded_port", guest: 8080, host: 22080

    tomcat2.vm.provision "yum", type: "shell", inline: <<-SHELL
    sudo systemctl restart network
    sudo systemctl stop firewalld.service
    sudo yum install java-1.8.0-openjdk -y
    sudo yum install tomcat tomcat-webapps tomcat-admin-webapps -y
    sudo systemctl start tomcat
    sudo systemctl enable tomcat
    sudo mkdir /usr/share/tomcat/webapps/new
    echo Hello from Tomcat 2| sudo tee -a /usr/share/tomcat/webapps/new/index.html >/dev/null	

    SHELL

  end

end