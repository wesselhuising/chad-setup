.PHONY: pull


pull:
	cp ~/.tmux.conf tmux/.tmux.conf
	cp -r ~/.config/nvim/ nvim/

install-tmux:
	git clone https://github.com/tmux/tmux.git ~/tmp/tmux-installation
	cd ~/tmp/tmux-installation && sh autogen.sh && ./configure && make && sudo make install
	rm -rf ~/tmp/tmux-installation
	ln -sf "$PWD/tmux/.tmux.conf" "$HOME"/.tmux.conf"

install-nvim:
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew install neovim
	ln -sf "$PWD/nvim/" "$HOME"/.config/nvim

install-osx:
	install-tmux
	install-nvim

install-linux:
	apt-get install automake libtool
	install-tmux
	install-nvim
