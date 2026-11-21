#!/usr/bin/env python3
# Shop On Design 상담 신청 수신 -> 텔레그램 알림 (외부 라이브러리 없음)
import json, os, time, urllib.request, urllib.parse
from http.server import BaseHTTPRequestHandler, HTTPServer

ENV = "/root/shopon/design-secret/env"
cfg = {}
for line in open(ENV, encoding="utf-8"):
    if "=" in line:
        k, v = line.strip().split("=", 1)
        cfg[k] = v
TOKEN, CHAT = cfg["BOT_TOKEN"], cfg["CHAT_ID"]
LOG = "/root/shopon/design-secret/inquiries.jsonl"
last = {}

def send(text):
    data = urllib.parse.urlencode({"chat_id": CHAT, "text": text}).encode()
    urllib.request.urlopen(f"https://api.telegram.org/bot{TOKEN}/sendMessage", data, timeout=10).read()

class H(BaseHTTPRequestHandler):
    def _out(self, code, obj):
        b = json.dumps(obj, ensure_ascii=False).encode()
        self.send_response(code); self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(b))); self.end_headers(); self.wfile.write(b)
    def log_message(self, *a): pass
    def do_POST(self):
        ip = self.headers.get("X-Real-IP", self.client_address[0])
        now = time.time()
        if now - last.get(ip, 0) < 30:
            return self._out(429, {"ok": False, "msg": "잠시 후 다시 시도해 주세요."})
        try:
            n = min(int(self.headers.get("Content-Length", 0)), 8000)
            d = json.loads(self.rfile.read(n) or b"{}")
        except Exception:
            return self._out(400, {"ok": False})
        if d.get("website"):  # 스팸 방지용 숨김 칸
            return self._out(200, {"ok": True})
        f = {k: str(d.get(k, "")).strip()[:500] for k in ("name", "contact", "biz", "category", "sample", "message", "lang")}
        if not f["name"] or not f["contact"]:
            return self._out(400, {"ok": False, "msg": "이름과 연락처를 적어 주세요."})
        last[ip] = now
        text = ("🛎 Shop On Design 상담 신청\n"
                f"이름: {f['name']}\n연락처: {f['contact']}\n업종/상호: {f['biz']}\n"
                f"관심 분야: {f['category']}\n고른 샘플: {f['sample']}\n언어: {f['lang']}\n\n{f['message']}")
        with open(LOG, "a", encoding="utf-8") as fp:
            fp.write(json.dumps({"t": int(now), **f}, ensure_ascii=False) + "\n")
        try:
            send(text)
        except Exception:
            return self._out(502, {"ok": False, "msg": "접수는 되었지만 알림 전송에 실패했습니다."})
        self._out(200, {"ok": True})

HTTPServer(("127.0.0.1", 8095), H).serve_forever()
