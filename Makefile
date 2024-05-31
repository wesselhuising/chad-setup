.PHONY: pull, install-tmux, install-nvim, install-osx, install-linux

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

install-osx:
	brew install tmux neovim
	install-tmux
	install-nvim

install-linux:
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	. "$HOME/.cargo/env" 
	cargo install alacritty
	apt install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
	sudo apt-get install tmux
	make install-tmux
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
	sudo rm -rf /opt/nvim
	sudo tar -C /opt -xzf nvim-linux64.tar.gz
	echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> ~/.bashrc
	echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> ~/.bash_profile
	make install-nvim
