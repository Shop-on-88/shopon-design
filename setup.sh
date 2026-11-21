#!/usr/bin/env bash
# Shop On Design - design.shoponph.online 설치
set -e
SRC=/root/shopon/design
WEB=/var/www/shopon-design
DOMAIN=design.shoponph.online

mkdir -p "$WEB"
rsync -a --delete --exclude '.git' --exclude 'setup.sh' --exclude 'update.sh' --exclude 'server' --exclude 'setup-inquiry.sh' "$SRC/" "$WEB/"

cat > /etc/nginx/sites-available/$DOMAIN <<EOF
server {
    listen 80;
    server_name $DOMAIN;
    root $WEB;
    index index.html;
    location / { try_files \$uri \$uri/ =404; }
}
EOF
ln -sf /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/$DOMAIN
nginx -t && systemctl reload nginx

certbot --nginx -d $DOMAIN --non-interactive --redirect --keep-until-expiring || echo "인증서 발급 실패: 위 메시지를 Claude에게 보내 주세요"

# 5분마다 저장소 변경을 받아 자동 반영
cat > $SRC/update.sh <<'EOF'
#!/usr/bin/env bash
cd /root/shopon/design && git pull -q && rsync -a --delete --exclude '.git' --exclude 'setup.sh' --exclude 'update.sh' --exclude 'server' --exclude 'setup-inquiry.sh' /root/shopon/design/ /var/www/shopon-design/
EOF
chmod +x $SRC/update.sh
( crontab -l 2>/dev/null | grep -v 'shopon/design/update.sh'; echo "*/5 * * * * /root/shopon/design/update.sh >/dev/null 2>&1" ) | crontab -

echo "완료: https://$DOMAIN"
