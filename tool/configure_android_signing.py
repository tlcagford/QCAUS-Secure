#!/usr/bin/env python3
"""Write android/key.properties from environment variables.

Do not commit android/key.properties or the keystore.
"""
from pathlib import Path
import os

required = [
    "ANDROID_STORE_PASSWORD",
    "ANDROID_KEY_PASSWORD",
    "ANDROID_KEY_ALIAS",
    "ANDROID_STORE_FILE",
]
missing = [k for k in required if not os.environ.get(k)]
if missing:
    raise SystemExit("Missing environment variables: " + ", ".join(missing))

path = Path("android/key.properties")
path.parent.mkdir(parents=True, exist_ok=True)
path.write_text(
    "\n".join(
        [
            f"storePassword={os.environ['ANDROID_STORE_PASSWORD']}",
            f"keyPassword={os.environ['ANDROID_KEY_PASSWORD']}",
            f"keyAlias={os.environ['ANDROID_KEY_ALIAS']}",
            f"storeFile={os.environ['ANDROID_STORE_FILE']}",
            "",
        ]
    ),
    encoding="utf-8",
)
print(f"Wrote {path}; keep it out of git.")
