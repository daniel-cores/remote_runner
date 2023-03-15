# Installation

```
git clone https://github.com/daniel-cores/remote_runner
cd remote_runner
chmod +x install.sh
./install.sh
```
# SSH keys (Optional)
```
ssh-copy-id -i ~/.ssh/id_rsa.pub user@remote-host
```

# Getting started
```
cd test_job
remote status $CLUSTER
remote run $CLUSTER run_remote.sh
remote queue $CLUSTER
```

Available clusters:
+ cesga
+ citius

Edit $HOME/.remote_runner/config.json to change cluster configuration. Change username and remote tmp path. The project directory will be copied to this temporal directory. SLURM output log files follow the pattern: ~/job_%j.log
