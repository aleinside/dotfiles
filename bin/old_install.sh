#!/bin/bash
set -e

# avoid interactive installation
export DEBIAN_FRONTEND=noninteractive

check_is_sudo() {
	if [ "$EUID" -ne 0 ]; then
		echo "Please run as root."
		exit
	fi
}

setup_sources() {
	apt-get update
	apt-get install -y \
		apt-transport-https \
		ca-certificates \
		curl \
		--no-install-recommends

  	# tlp: Advanced Linux Power Management
  	# http://linrunner.de/en/tlp/docs/tlp-linux-advanced-power-management.html
  	#add-apt-repository -y ppa:linrunner/tlp

  	# Docker key
  	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

  	# Neovim ppa
  	add-apt-repository -y ppa:neovim-ppa/unstable

  	# $(lsb_release -cs) -> xenial
  	add-apt-repository -y \
     		"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     		xenial \
     		stable"

  	# Google Chromes
  	wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
  	sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'

  	# Atom ppa
  	#add-apt-repository -y ppa:webupd8team/atom

	# turn off translations, speed up apt-get update
	mkdir -p /etc/apt/apt.conf.d
	echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/99translations
}

# 		git \

base() {
	apt-get update
	apt-get -y upgrade

	apt-get install -y \
		atom \
		awscli \
		cmake \
		google-chrome-stable \
		htop \
		jq \
		make \
		mysql-workbench \
		neovim \
		network-manager-openvpn-gnome \
		openvpn \
		python-dev \
		python-pip \
		python3-dev \
		python3-pip \
		redshift-gtk \
		software-properties-common \
		tree \
		vlc \
		xclip \
		zsh \
		--no-install-recommends

	# install tlp with recommends
	#apt-get install -y tlp tlp-rdw

	apt-get autoremove
	apt-get autoclean
	apt-get clean

	install_oh_my_zsh
	install_docker
}

install_docker() {
		echo "fallo a mano che tanto non funziona..."
  	#apt-get install -y \
    #		linux-image-extra-$(uname -r) \
    #		linux-image-extra-virtual
  	#apt-get install -y docker-ce docker-compose
  	#groupadd docker
  	#usermod -aG docker $USER
  	#systemctl enable docker
}

install_oh_my_zsh() {
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	chsh -s `which zsh` $USER
}

install_php_cli() {
	echo "sistema asdf"
	#apt-get install -y \
	#	php-cli \
	#	php-mbstring \
	#	php-sqlite3 \
	#	php-xml
}

install_elixir() {
	echo "sistema asdf"
	#wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && dpkg -i erlang-solutions_1.0_all.deb
	#apt-get update
	#apt-get install -y esl-erlang
	#apt-get install -y elixir
}

install_asdf() {
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.3.0
	echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.zshrc
	echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.zshrc
}

install_ruby() {
	asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
	asdf install ruby 2.4.1
	asdf global ruby 2.4.1
}

install_gem() {
	gem install prima-twig
}

install_fzf() {
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install
}

get_dotfiles() {
	# create subshell
	(
	cd "$HOME"

	DOTFILESDIR="${HOME}/Works/dotfiles"

	echo "Copy aliases \n"
	cat ${DOTFILESDIR}/aliases >> ${HOME}/.zshrc

	echo "Copy git configuration \n"
	cp ${DOTFILESDIR}/git/gitconfig ${HOME}/.gitconfig
	cp ${DOTFILESDIR}/git/gitignore_global ${HOME}/.gitignore_global

	echo "Setup aws \n"
	#mkdir ${HOME}/.aws
	#cp ${DOTFILESDIR}/aws/config ${HOME}/.aws/config

	#echo "Copy openvpn files \n"
	#cp -R ${DOTFILESDIR}/openvpn ${HOME}/Works

	echo "SSH key"
	)
	#generate_ssh
}

usage() {
	echo -e "install.sh\n\tInstall base setup\n"
	echo "Usage:"
	echo "  sources                     - setup sources & install base pkgs"
	echo "  dotfiles                    - get dotfiles"
	echo "	asdf												- install asdf"
	echo "  php-cli                     - install PHP cli"
	echo "  elixir                      - install elixir"
	echo "  gem                         - install ruby-gems"
	echo "  fzf                         - install command line fuzzy finder"
}

main() {
	local cmd=$1

	if [[ -z "$cmd" ]]; then
		usage
		exit 1
	fi

	if [[ $cmd == "sources" ]]; then
		check_is_sudo
		setup_sources
		base
	elif [[ $cmd == "dotfiles" ]]; then
		get_dotfiles
	elif [[ $cmd == "php-cli" ]]; then
		check_is_sudo
		install_php_cli
	elif [[ $cmd == "elixir" ]]; then
		check_is_sudo
		install_elixir
	elif [[ $cmd == "asdf" ]]; then
		check_is_sudo
		install_asdf
	elif [[ $cmd == "gem" ]]; then
		check_is_sudo
		install_gem
	elif [[ $cmd == "fzf" ]]; then
		install_fzf
	else
		usage
	fi
}

main "$@"
