# Linux & DevOps Journey

Author: Asif Pancharayil

This repository documents my practical transition from
Linux System Administration to Cloud and DevOps Engineering.

Areas:
- Linux Administration
- Bash Automation
- Git
- Ansible
- Docker
- Kubernetes
- Terraform
- CI/CD
- Cloud
- Monitoring


## Systemd Automation

The Linux health-check script can be automated using a systemd service and timer.

### Components

* `linux-health-check.sh` - Performs CPU, disk, and memory health checks.
* `systemd/linux-health-check.service` - Runs the health-check script as a oneshot systemd service.
* `systemd/linux-health-check.timer` - Runs the service automatically every 15 minutes.
* `health-check-logrotate.conf` - Controls rotation of the generated health-check log.

### Install the systemd units

Copy the service and timer files:

```bash
sudo cp systemd/linux-health-check.service /etc/systemd/system/
sudo cp systemd/linux-health-check.timer /etc/systemd/system/
```

Before enabling the service, update the `User` and `ExecStart` values in `linux-health-check.service` if your username or project path is different.

Reload systemd:

```bash
sudo systemctl daemon-reload
```

Enable and start the timer:

```bash
sudo systemctl enable --now linux-health-check.timer
```

### Verify the timer

```bash
systemctl status linux-health-check.timer
systemctl list-timers --all | grep linux-health-check
```

### Run the health check manually

```bash
sudo systemctl start linux-health-check.service
systemctl status linux-health-check.service
```

Because the service uses `Type=oneshot`, it normally returns to an inactive state after the health check finishes successfully.

### View logs

View systemd journal entries:

```bash
journalctl -u linux-health-check.service
```

View the application log:

```bash
cat logs/health-check.log
```

The timer runs the health check every 15 minutes.
