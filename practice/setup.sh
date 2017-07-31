sudo yum update
sudo yum install -y docker git neovim
sudo usermod -a -G docker ec2-user
sudo curl -L https://github.com/docker/compose/releases/download/1.15.0/docker-compose-`uname -s`-`uname -m` | sudo tee /usr/local/bin/docker-compose > /dev/null
sudo chmod +x /usr/local/bin/docker-compose
sudo service docker start
sudo chkconfig docker on

# ssh -> aggiungere a git
ssh-keygen -t rsa -b 4096 -C "aleinside@gmail.com" -P "" -f $HOME/.ssh/id_rsa -q

# dotfiles
# htop, jq, tree, openvpn, zsh
# asdf: ruby, elixir - (elm-format)
# fuzzy-finder
