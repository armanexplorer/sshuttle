# SSHuttle in use

Make use of [sshuttle](https://github.com/sshuttle/sshuttle) to tunnel system in robust and flexible way.

## Auto setup (using Makefile)

You should have installed `make` package. You can run only `make` to setup all components or you can run `make` with custom actions.

```bash
make
```

## Manual Setup

First, you should install [sshuttle](https://github.com/sshuttle/sshuttle) according to its [manual](https://sshuttle.readthedocs.io/en/stable/installation.html). Mostly, the following command is enough:

```bash
sudo apt install sshuttle
```

Then, you should install a systemd service template and a bash script to be able to make sshuttle in control:

```bash
# clone repo
git clone https://github.com/armanexplorer/sshuttle.git

# make the service template ready
sudo cp sshuttle/sshuttle@.service /etc/systemd/system/
sudo systemctl daemon-reload

# make the control script ready
sudo cp sshuttle/vpn.sh /usr/local/bin/vpn
sudo chmod u+x /usr/local/bin/vpn
```

## Run

To start vpn:

```bash
sudo vpn <user>@<server>
```

You can also use `/root/.ssh/config` file to define alias names instead of `<user>@<server>`.

**Note**: The controller script (`vpn`) only allows for one active VPN. You can change it with disabling the `if` condition in the `vpn.sh` before installing it.

To stop the all VPNs activated using this tool, simply run:

```bash
sudo vpn off
```

## Troubleshoot

You can check logs using `sudo journalctl -xeu "sshuttle@<user>@<server>.service"`.

In case of `Host key authentication failed` error in the logs, you can add `--ssh-cmd "ssh -i /home/user/.ssh/custom_id"` flag to the `sshuttle@.service` file and run `sudo systemctl daemon-reload`. Using this, you will specify the full path to your custom SSH key, instead of using the default one.
