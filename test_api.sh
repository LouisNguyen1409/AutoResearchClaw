#!/bin/bash
find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null
python3 -c "
from researchclaw.config import RCConfig
from researchclaw.llm import create_llm_client

config = RCConfig.load('config_hpc_h200.yaml', check_paths=False)
client = create_llm_client(config)
ok, msg = client.preflight()
print(msg)
"
