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
	mkdir -p ~/.config
	ln -sf $(CURDIR)/nvim ~/.config/nvim
	pip install --index-url https://pypi.org/simple "python-lsp-server[all]" --user --break-system-packages
	pip install --index-url https://pypi.org/simple python-lsp-black --user --break-system-packages
	pip install --index-url https://pypi.org/simple pylsp-mypy --user --break-system-packages
	pip install --index-url https://pypi.org/simple python-lsp-isort --user --break-system-packages
	pip install --index-url https://pypi.org/simple jupytext --user --break-system-packages
	pip install --index-url https://pypi.org/simple ruff --user --break-system-packages
	pip install --index-url https://pypi.org/simple neovim --user --break-system-packages

install-lazygit-linux:
	rm -rf lazygit
	curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_$(LAZYGIT_VERSION)_Linux_x86_64.tar.gz"
	tar xf lazygit.tar.gz lazygit
	sudo install lazygit /usr/local/bin

install-fzf:
	rm -rf ~/.fzf
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install
	# Set up fzf key bindings and fuzzy completion
	eval "$(fzf --bash)"


install-cargo:
	curl https://sh.rustup.rs -sSf | sh
	. "$(HOME)/.cargo/env"

install-osx:
	chsh -s /bin/bash
	brew update
	brew install -f tmux neovim lazygit pyenv python@3.11 font-fira-code-nerd-font git-delta ripgrep fd wget go luarocks alt-tab rectangle npm raycast
	echo 'export PATH="$(brew --prefix)/opt/python@3.11/libexec/bin:$(PATH)"' >> ~/.bashrc
	make install-tmux
	make install-nvi
	rm -rf ~/alacritty/
	ln -sf $(CURDIR)/alacritty ~/.config/alacritty
	echo 'export XDG_CONFIG_HOME="~/.config"' >> ~/.bashrc
	rm -rf ~/.config/lazygit
	ln -sf $(CURDIR)/lazygit ~/.config/lazygit
	make install-fzf
	make install-cargo

install-linux:
	sudo apt update
	sudo chown jupyter:mollievertex ~/.bashrc
	sudo chown jupyter:mollievertex ~/.bash_profile
	sudo apt install libfontconfig1-dev libfontconfig ripgrep fd-find xsel
	make install-cargo
	. $(HOME)/.cargo/env && cargo install alacritty
	sudo apt install cmake pkg-config libfreetype6-dev libxcb-xfixes0-dev libxkbcommon-dev python3
	sudo apt install tmux
	make install-tmux
	curl -LO https://github.com/neovim/neovim-releases/releases/download/v0.11.0/nvim-linux-x86_64.tar.gz
	sudo rm -rf /opt/nvim
	sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
	sudo echo 'export PATH="${PATH}:/opt/nvim-linux-x86_64/bin"' >> ~/.bashrc
	curl -LO https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep_14.1.0-1_amd64.deb
	make install-lazygit-linux
	make install-nvim
	make install-fzf
	rm -rf ~/.config/lazygit
	mkdir ~/.config/lazygit
	ln -sf $(CURDIR)/lazygit_config.yml ~/.config/lazygit/config.yml
