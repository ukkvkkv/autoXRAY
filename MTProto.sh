

SECRET="$(openssl rand -hex 16)"

curl -fsSL -o MTProtoProxyOfficialInstall.sh https://git.io/fjo3u
bash MTProtoProxyOfficialInstall.sh --port 4443 --secret "$SECRET" --workers 10 --tls "vk.ru"

IP="$(hostname -I | awk '{print $1}')"

if [[ -z "${IP:-}" ]]; then
  echo "Ошибка: не удалось определить IP сервера."
  exit 1
fi

TGLINK="tg://proxy?server=${IP}&port=4443&secret=${SECRET}"

systemctl start MTProxy

cat > /etc/sysctl.conf <<'EOF'
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
EOF

sysctl -p