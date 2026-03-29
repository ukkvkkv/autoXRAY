
cat > /etc/sysctl.conf <<'EOF'
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
EOF

sysctl -p

set -euo pipefail

apt install -y cron

systemctl enable cron
systemctl start cron

CRON_JOB="0 2 * * * reboot"

( crontab -l 2>/dev/null | grep -v -F "$CRON_JOB" ; echo "$CRON_JOB" ) | crontab -

echo "Готово. Текущий crontab:"
crontab -l