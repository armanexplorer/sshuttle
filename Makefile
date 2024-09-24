.PHONY: all help install-service install-controller install-sshuttle

# Specify bash as the shell
SHELL := /bin/bash

# Define the script path
SELECT_KEY_SCRIPT := ./select_ssh_key.sh

all: install-sshuttle install-service install-controller

help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ {printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

install-sshuttle: ## install sshuttle
	sudo apt install sshuttle

install-service: ## install systemd service template
	chmod u+x $(SELECT_KEY_SCRIPT)
	@source $(SELECT_KEY_SCRIPT) && \
	echo "Using SSH key: $$SELECTED_SSH_KEY" && \
	sed -i "s|SSH_CUSTOM_KEY_PATH|$$SELECTED_SSH_KEY|" 'sshuttle@.service'
	sudo cp sshuttle@.service /etc/systemd/system/
	sudo systemctl daemon-reload

install-controller: ## install `vpn` controller
	sudo cp vpn.sh /usr/local/bin/vpn
	sudo chmod u+x /usr/local/bin/vpn
