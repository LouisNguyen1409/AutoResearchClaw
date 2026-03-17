#!/bin/bash
find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null
python3 << 'PYEOF'
import json
import os
import urllib.request
import urllib.error

api_key = os.environ.get("OPENAI_API_KEY", "")
url = "https://api.openai.com/v1/chat/completions"

body = {
    "model": "gpt-5.4",
    "messages": [{"role": "user", "content": "Say hello"}],
    "max_completion_tokens": 64,
    "reasoning": {"effort": "high"},
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
        print("SUCCESS:", data["choices"][0]["message"]["content"][:100])
        print("MODEL:", data.get("model"))
except urllib.error.HTTPError as e:
    error_body = e.read().decode()
    print(f"HTTP {e.code}: {error_body}")
PYEOF
