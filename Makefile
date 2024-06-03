.PHONY: pull, install-tmux, install-nvim, install-osx, install-linux

LAZYGIT_VERSION=$(shell curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')

pull:
	cp ~/.tmux.conf tmux/.tmux.conf
	cp -r ~/.config/nvim/ nvim/

test:
	echo $(CURDIR)

install-tmux:
	ln -sf $(CURDIR)/tmux/.tmux.conf ~/.tmux.conf
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

install-nvim:
	ln -sf $(CURDIR)/nvim ~/.config/nvim

install-terraform-linux:
	sudo apt update && sudo apt install -y gnupg software-properties-common
	wget -O- https://apt.releases.hashicorp.com/gpg | \
		gpg --dearmor | \
		sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
		gpg --no-default-keyring \
		--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
		--fingerprint
	echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
		https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
		sudo tee /etc/apt/sources.list.d/hashicorp.list
	sudo apt update
	sudo apt install terraform

install-lazygit-linux:
	curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_$(LAZYGIT_VERSION)_Linux_x86_64.tar.gz"
	tar xf lazygit.tar.gz lazygit
	sudo install lazygit /usr/local/bin

install-osx:
	brew install tmux neovim
	install-tmux
	install-nvim

install-linux:
	sudo apt install libfontconfig1-dev libfontconfig ripgrep
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	. $(HOME)/.cargo/env 
	cargo install alacritty
	sudo apt install cmake pkg-config libfreetype6-dev libxcb-xfixes0-dev libxkbcommon-dev python3
	sudo apt-get install tmux
	make install-tmux
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
	sudo rm -rf /opt/nvim
	sudo tar -C /opt -xzf nvim-linux64.tar.gz
	echo 'export PATH="$(PATH):/opt/nvim-linux64/bin"' >> ~/.bashrc
	echo 'export PATH="$(PATH):/opt/nvim-linux64/bin"' >> ~/.bash_profile
	curl -LO https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep_14.1.0-1_amd64.deb
	make install-lazygit-linux
	make install-nvim
	make install-terraform-linux
