#!/usr/bin/env bash
# 상담 신청 알림 설치: bash setup-inquiry.sh '<봇토큰>'
set -e
TOKEN="$1"; [ -z "$TOKEN" ] && { echo "사용법: bash setup-inquiry.sh '<봇토큰>'"; exit 1; }
S=/root/shopon/design-secret; mkdir -p $S; chmod 700 $S
printf 'BOT_TOKEN=%s\nCHAT_ID=2103748907\n' "$TOKEN" > $S/env; chmod 600 $S/env
cat > /etc/systemd/system/shopon-inquiry.service <<UNIT
[Unit]
Description=Shop On Design inquiry -> Telegram
After=network.target
[Service]
ExecStart=/usr/bin/python3 /root/shopon/design/server/inquiry.py
Restart=always
[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload; systemctl enable --now shopon-inquiry; systemctl restart shopon-inquiry
CONF=/etc/nginx/sites-available/design.shoponph.online
grep -q '/api/inquiry' $CONF || sed -i '0,/location \/ {/s//location \/api\/inquiry { proxy_pass http:\/\/127.0.0.1:8095; proxy_set_header X-Real-IP $remote_addr; client_max_body_size 16k; }\n    location \/ {/' $CONF
sed -i "s#--exclude 'update.sh' /root#--exclude 'update.sh' --exclude 'server' --exclude 'setup-inquiry.sh' /root#" /root/shopon/design/update.sh; rm -rf /var/www/shopon-design/server /var/www/shopon-design/setup-inquiry.sh
nginx -t && systemctl reload nginx
curl -s -X POST -H 'Content-Type: application/json' -d '{"name":"설치 테스트","contact":"-","message":"상담 신청 알림이 연결되었습니다.","lang":"ko"}' http://127.0.0.1:8095/ && echo
echo "완료: 텔레그램에 '설치 테스트' 알림이 왔는지 확인하세요"
