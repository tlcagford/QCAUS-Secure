#!/usr/bin/env python3
"""Configure Android release signing after flutter create.

Required environment:
  ANDROID_STORE_PASSWORD
  ANDROID_KEY_PASSWORD
  ANDROID_KEY_ALIAS
  ANDROID_STORE_FILE

The keystore must already exist at ANDROID_STORE_FILE.
"""
from pathlib import Path
import os
import re

required = [
    "ANDROID_STORE_PASSWORD",
    "ANDROID_KEY_PASSWORD",
    "ANDROID_KEY_ALIAS",
    "ANDROID_STORE_FILE",
]
missing = [x for x in required if not os.environ.get(x)]
if missing:
    raise SystemExit("Missing environment variables: " + ", ".join(missing))

app = Path("android/app")
target = app / "build.gradle.kts"
if not target.exists():
    target = app / "build.gradle"
if not target.exists():
    raise SystemExit("Run tool/bootstrap_store first.")

store_file = os.environ["ANDROID_STORE_FILE"].replace("\\", "\\\\")
props = (
    f"storePassword={os.environ['ANDROID_STORE_PASSWORD']}\n"
    f"keyPassword={os.environ['ANDROID_KEY_PASSWORD']}\n"
    f"keyAlias={os.environ['ANDROID_KEY_ALIAS']}\n"
    f"storeFile={store_file}\n"
)
Path("android/key.properties").write_text(props, encoding="utf-8")

text = target.read_text(encoding="utf-8")

if target.name.endswith(".kts"):
    if "val keystoreProperties = Properties()" not in text:
        text = "import java.util.Properties\nimport java.io.FileInputStream\n\n" + text
        marker = "plugins {"
        insert = """val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

"""
        text = text.replace(marker, insert + marker, 1)
    if 'create("release")' not in text:
        block = """        signingConfigs {
            create("release") {
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                storeFile = keystoreProperties.getProperty("storeFile")?.let { file(it) }
                storePassword = keystoreProperties.getProperty("storePassword")
            }
        }
"""
        text = text.replace("    buildTypes {", block + "    buildTypes {", 1)
    text = re.sub(
        r'(buildTypes\s*\{\s*release\s*\{[^}]*?signingConfig\s*=\s*)signingConfigs\.getByName\("debug"\)',
        r'\1signingConfigs.getByName("release")',
        text, count=1, flags=re.S
    )
else:
    if "def keystoreProperties = new Properties()" not in text:
        text = "import java.util.Properties\nimport java.io.FileInputStream\n\n" + text
        marker = "plugins {"
        insert = """def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

"""
        text = text.replace(marker, insert + marker, 1)
    if "signingConfigs {" not in text:
        block = """        signingConfigs {
            release {
                keyAlias keystoreProperties['keyAlias']
                keyPassword keystoreProperties['keyPassword']
                storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
                storePassword keystoreProperties['storePassword']
            }
        }
"""
        text = text.replace("    buildTypes {", block + "    buildTypes {", 1)
    text = re.sub(
        r'(buildTypes\s*\{\s*release\s*\{[^}]*?signingConfig\s*=\s*)signingConfigs\.debug',
        r'\1signingConfigs.release',
        text, count=1, flags=re.S
    )

target.write_text(text, encoding="utf-8")
print(f"Configured release signing in {target}.")
