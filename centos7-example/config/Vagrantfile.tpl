# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
	config.vm.box_url = "ijelo-c7-simple-x64-virtualbox-minimal.box"
	config.vm.provider :virtualbox do |p|
		p.customize ["modifyvm", :id, "--memory", 1024]
		p.customize ["modifyvm", :id, "--cpus", 1]
#		p.customize ["modifyvm", :id, "--cpuexecutioncap", 50]
	end

	config.vm.network "forwarded_port", guest: 80, host: 8000

        config.vm.box = "ijelo/c7-simple"
        config.vm.hostname = "ijelo-c7-simple"
        config.vm.define "ijelo-c7-simple"
        config.vm.provider :virtualbox do |vb|
          vb.name = "ijelo-c7-simple"
        end

        config.vm.provision :shell, path: "bootstrap.sh"


        config.vm.network "private_network", ip: "192.168.200.200", virtualbox__intnet: "backend.hq.ijelo.net"

	#config.vm.provision "ansible" do |ansible|
	#	ansible.playbook = "provisioning/site.yml"
	#	ansible.host_key_checking = false
	#	ansible.raw_ssh_args = '-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PasswordAuthentication=no -o IdentitiesOnly=yes'
	#end
end

