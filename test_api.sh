#!/bin/bash
find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null
python3 << 'PYEOF'
from researchclaw.config import RCConfig
from researchclaw.llm import create_llm_client

config = RCConfig.load('config_hpc_h200.yaml', check_paths=False)
client = create_llm_client(config)

print(f"Model: {config.llm.primary_model}")
print(f"Reasoning effort: {config.llm.reasoning_effort}")

try:
    resp = client.chat(
        [{"role": "user", "content": "What is 2+2? Reply with just the number."}],
        max_tokens=64,
    )
    print(f"SUCCESS: model={resp.model}")
    print(f"Content: {resp.content.strip()[:200]}")
    print(f"Tokens: prompt={resp.prompt_tokens}, completion={resp.completion_tokens}")
except Exception as e:
    print(f"FAILED: {type(e).__name__}: {e}")
PYEOF
