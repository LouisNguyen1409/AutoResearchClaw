#!/bin/bash
find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null
python3 << 'PYEOF'
import json
import os
import urllib.request
import urllib.error

api_key = os.environ.get("OPENAI_API_KEY", "")
url = "https://api.openai.com/v1/responses"

body = {
    "model": "gpt-5.4",
    "input": [{"role": "user", "content": "What is 2+2? Reply with just the number."}],
    "reasoning": {"effort": "high"},
    "max_output_tokens": 256,
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
    with urllib.request.urlopen(req, timeout=60) as resp:
        data = json.loads(resp.read())
        print(json.dumps(data, indent=2)[:3000])
except urllib.error.HTTPError as e:
    error_body = e.read().decode()
    print(f"HTTP {e.code}: {error_body[:500]}")
PYEOF
