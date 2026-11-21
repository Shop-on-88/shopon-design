#!/usr/bin/env bash
# 새 "샘플:" 커밋이 들어오면 텔레그램으로 알림 (update.sh 가 pull 직후 호출)
S=/root/shopon/design-secret
STATE=$S/last_notified_commit
cd /root/shopon/design || exit 0
. <(grep -E '^(BOT_TOKEN|CHAT_ID)=' $S/env)
HEAD=$(git rev-parse HEAD)
LAST=$(cat $STATE 2>/dev/null)
[ -z "$LAST" ] && { echo "$HEAD" > $STATE; exit 0; }
[ "$HEAD" = "$LAST" ] && exit 0
MSGS=$(git log --format=%s "$LAST..$HEAD" 2>/dev/null | grep '^샘플:' | sed 's/^샘플: */• /')
echo "$HEAD" > $STATE
[ -z "$MSGS" ] && exit 0
TEXT=$(printf '🆕 Shop On Design 새 샘플이 올라왔습니다\n%s\n\nhttps://design.shoponph.online/#templates' "$MSGS")
curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
  --data-urlencode "chat_id=${CHAT_ID}" --data-urlencode "text=${TEXT}" >/dev/null
