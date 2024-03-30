.PHONY: all help install-service install-controller install-sshuttle
 
help:
	@echo "Available targets:"
	@awk '/^[a-zA-Z_-]+:.*?##/ { printf "\033[36m%-30s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST) | sort


all: install-sshuttle install-service install-controller

install-sshuttle:  ## install sshuttle
	sudo apt install sshuttle

install-service:  ## install systemd service template
	wget "https://raw.githubusercontent.com/armanexplorer/sshuttle/main/sshuttle@.service"
	sudo cp sshuttle@.service /etc/systemd/system/
	sudo systemctl daemon-reload

install-controller: ## install `vpn` controller
	wget "https://raw.githubusercontent.com/armanexplorer/sshuttle/main/vpn.sh"
	sudo cp vpn.sh /usr/local/bin/vpn
	sudo chmod u+x /usr/local/bin/vpn