# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "512"
    vb.customize ["modifyvm", :id, "--audio", "none"]
  end

  # must be at the top
  config.vm.define "lb-0" do |c|
      c.vm.hostname = "lb-0"
      c.vm.network "private_network", ip: "192.168.199.40"

      c.vm.provision :shell, :path => "scripts/vagrant-setup-haproxy.bash"

      c.vm.provider "virtualbox" do |vb|
        vb.memory = "256"
      end
  end

  (0..2).each do |n|
    config.vm.define "controller-#{n}" do |c|
        c.vm.hostname = "controller-#{n}"
        c.vm.network "private_network", ip: "192.168.199.1#{n}"

        c.vm.provision :shell, :path => "scripts/vagrant-setup-hosts-file.bash"

        c.vm.provider "virtualbox" do |vb|
          vb.memory = "640"
        end
    end
  end

  (0..2).each do |n|
    config.vm.define "worker-#{n}" do |c|
        c.vm.hostname = "worker-#{n}"
        c.vm.network "private_network", ip: "192.168.199.2#{n}"

        c.vm.provision :shell, :path => "scripts/vagrant-setup-routes.bash"
        c.vm.provision :shell, :path => "scripts/vagrant-setup-hosts-file.bash"
    end
  end

  # 192.168.199.30 will be the ingress IP, acc
  # curl -H "Host: app.domain" 192.168.199.30
  config.vm.define "traefik-0" do |c|
      c.vm.hostname = "traefik-0"
      c.vm.network "private_network", ip: "192.168.199.30"

      c.vm.provision :shell, :path => "scripts/vagrant-setup-routes.bash"
  end


  config.vm.define "nfsserver-0" do |c|
      c.vm.hostname = "nfsserver-0"
      c.vm.network "private_network", ip: "192.168.199.50"

      c.vm.provision :shell, :path => "scripts/vagrant-setup-nfsserver.bash"    
  end

  # config.vm.define "docker-0" do |c|
  #   c.vm.hostname = "docker-0"
  #   c.vm.network "private_network", ip: "192.168.199.60"

  #   c.vm.provision :shell, :path => "scripts/vagrant-setup-docker.bash"    
  # end
end
