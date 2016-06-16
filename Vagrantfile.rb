# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.network :forwarded_port, guest: 4000, host: 1234
  config.vm.network :forwarded_port, guest: 3306, host: 33306
  
  config.vm.provider "virtualbox" do |vb|
    # vb.gui = true
    # vb.memory = "1024"
  end

  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update

    # Installation des dépendances systemes
    sudo apt-get install -y make ruby-full ruby-dev git libsqlite3-dev sqlite3 build-essential g++ libssl-dev
    sudo apt-get install -y libreadline-dev
    sudo apt-get install -y libreadline6 libreadline6-dev
    
    # Installation de mysql
    sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password mysqlpwd'
    sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password mysqlpwd'
    sudo apt-get install -y mysql-server libmysqlclient-dev

    # Installation de bower
    sudo apt-get install -y nodejs npm nodejs-legacy
    sudo npm install -g bower
        
    # curl https://raw.githubusercontent.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash
    # export RBENV_ROOT="${HOME}/.rbenv" >> /home/vagrant/.bashrc
    # if [ -d "${RBENV_ROOT}" ]; then >> /home/vagrant/.bashrc
    #   export PATH="${RBENV_ROOT}/bin:${PATH}" >> /home/vagrant/.bashrc
    #   eval "$(rbenv init -)" >> /home/vagrant/.bashrc
    # fi >> /home/vagrant/.bashrc
    # source /home/vagrant/.bashrc
    
    # # if rbenv global contains
    # cd /vagrant
    # rbenv install `cat /vagrant/.ruby-version`
    #
    # cd /vagrant
    # gem install bundler
    # rbenv rehash
    # bundle install
    
    # Creation base de donnees
    # bundle exec rake db:setup

    # Modifier dans le fichier @/etc/mysql/my.cnf@, la ligne suivante pour la mettre en commentaire :
    # # bind-address = 127.0.0.1

    # Donner les droits à l'utilisateur pour toutes les bases " . ", de discuter avec tous les serveurs distants '%'
    # mysql  -u root -h localhost -p
    # grant all privileges on * . * to 'root'@'%' identified by "mysqlpwd";
    # flush privileges;

  SHELL
end
