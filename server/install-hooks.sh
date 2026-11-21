#!/usr/bin/env bash
# update.sh 가 pull 후 새 샘플 알림을 보내도록 연결 (한 번만 실행)
set -e
cat > /root/shopon/design/update.sh <<'EOF'
#!/usr/bin/env bash
cd /root/shopon/design && git pull -q && rsync -a --delete --exclude '.git' --exclude 'setup.sh' --exclude 'update.sh' --exclude 'server' --exclude 'setup-inquiry.sh' --exclude 'docs' /root/shopon/design/ /var/www/shopon-design/ && bash /root/shopon/design/server/notify_samples.sh
EOF
chmod +x /root/shopon/design/update.sh /root/shopon/design/server/notify_samples.sh
rm -rf /var/www/shopon-design/docs /var/www/shopon-design/server
bash /root/shopon/design/server/notify_samples.sh
echo "완료: 새 샘플이 올라오면 텔레그램으로 알림이 갑니다"
