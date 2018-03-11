VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

alertmanager_auth_username = ENV['GMAIL_ACCOUNT']
alertmanager_auth_pass = ENV['GMAIL_PASS']
alertmanager_to = ENV['GMAIL_TO']


  config.vm.provider "virtualbox" do |v|
    v.memory = 2024
    v.cpus = 2
    config.ssh.forward_agent = true
  end

  config.vm.box = "bento/centos-7.2"
  config.vm.network :private_network, ip: "10.0.99.4"
  config.vm.network "forwarded_port", guest: 9090, host: 9090
  config.vm.network "forwarded_port", guest: 9100, host: 9100
  config.vm.network "forwarded_port", guest: 9093, host: 9093

  config.vm.provision :ansible do |ansible|
    ansible.playbook = "provisioning/vagrant-provision.yml"
    ansible.extra_vars = {
        alertmanager_auth_username: alertmanager_auth_username,
        alertmanager_auth_pass: alertmanager_auth_pass,
        alertmanager_to: alertmanager_to
    }
  end
end

