#!/bin/bash
find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null
python3 << 'PYEOF'
import json
import os
import urllib.request
import urllib.error

api_key = os.environ.get("OPENAI_API_KEY", "")
url = "https://api.openai.com/v1/chat/completions"

# Test 1: gpt-5.4 WITHOUT reasoning
body = {
    "model": "gpt-5.4",
    "messages": [{"role": "user", "content": "Say hello"}],
    "max_completion_tokens": 64,
}

payload = json.dumps(body).encode("utf-8")
req = urllib.request.Request(
    url,
    data=payload,
    headers={
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json",
    },
)

try:
    with urllib.request.urlopen(req, timeout=30) as resp:
        data = json.loads(resp.read())
        print("gpt-5.4 (no reasoning): SUCCESS -", data.get("model"))
except urllib.error.HTTPError as e:
    error_body = e.read().decode()
    print(f"gpt-5.4 (no reasoning): FAILED - HTTP {e.code}: {error_body[:200]}")
PYEOF
