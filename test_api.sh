#!/bin/bash
find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null
python3 << 'PYEOF'
from researchclaw.llm.client import LLMClient, LLMConfig

config = LLMConfig(
    base_url="https://api.openai.com/v1",
    api_key="",  # will use env var
    primary_model="gpt-5.4",
    fallback_models=[],
    reasoning_effort="high",
)

import os
config = LLMConfig(
    base_url="https://api.openai.com/v1",
    api_key=os.environ.get("OPENAI_API_KEY", ""),
    primary_model="gpt-5.4",
    fallback_models=[],
    reasoning_effort="high",
)

client = LLMClient(config)

try:
    resp = client.chat(
        [{"role": "user", "content": "Say hello"}],
        max_tokens=64,
    )
    print(f"SUCCESS: model={resp.model}, content={resp.content[:100]}")
except Exception as e:
    print(f"FAILED: {e}")
PYEOF
