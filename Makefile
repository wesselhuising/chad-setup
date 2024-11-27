.PHONY: pull, install-tmux, install-nvim, install-osx, install-linux

LAZYGIT_VERSION=$(shell curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')

pull:
	cp ~/.tmux.conf tmux/.tmux.conf
	cp -r ~/.config/nvim/ nvim/

install-tmux:
	ln -sf $(CURDIR)/tmux/.tmux.conf ~/.tmux.conf
	rm -rf ~/.tmux/plugins/tpm
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

install-nvim:
	rm -rf ~/.config/nvim
	ln -sf $(CURDIR)/nvim ~/.config/nvim
	pip install "python-lsp-server[all]" --user
	pip install python-lsp-black --user
	pip install pylsp-mypy --user
	pip install python-lsp-isort --user
	pip install jupytext --user
	pip install ruff --user

install-lazygit-linux:
	curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_$(LAZYGIT_VERSION)_Linux_x86_64.tar.gz"
	tar xf lazygit.tar.gz lazygit
	sudo install lazygit /usr/local/bin

install-osx:
	chsh -s /bin/bash
	brew update
	brew install tmux neovim lazygit pyenv python@3.11
	echo 'export PATH="$(brew --prefix)/opt/python@3.11/libexec/bin:$(PATH)"' >> ~/.bashrc
	make install-tmux
	make install-nvim
	rm -rf ~/alacritty/
	ln -sf $(CURDIR)/alacritty/alacritty.toml ~/alacritty.toml
	echo 'export XDG_CONFIG_HOME="~/.config"' >> ~/.bashrc
	rm -rf ~/.config/lazygit
	ln -sf $(CURDIR)/lazygit ~/.config/lazygit

install-linux:
	sudo apt update
	sudo chown jupyter:mollievertex ~/.bashrc
	sudo chown jupyter:mollievertex ~/.bash_profile
	sudo apt install libfontconfig1-dev libfontconfig ripgrep fd-find xsel
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	. $(HOME)/.cargo/env && cargo install alacritty
	sudo apt install cmake pkg-config libfreetype6-dev libxcb-xfixes0-dev libxkbcommon-dev python3
	sudo apt install tmux
	make install-tmux
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
	sudo rm -rf /opt/nvim
	sudo tar -C /opt -xzf nvim-linux64.tar.gz
	sudo echo 'export PATH="$(PATH):/opt/nvim-linux64/bin"' >> ~/.bashrc
	sudo echo 'export PATH="$(PATH):/opt/nvim-linux64/bin"' >> ~/.bash_profile
	curl -LO https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep_14.1.0-1_amd64.deb
	make install-lazygit-linux
	make install-nvim
	rm -f ~/.config/lazygit/config.yml
	ln -s lazygit/config.yml ~/.config/lazygit/config.yml
